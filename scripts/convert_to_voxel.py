import math
import os
import shutil
import sys
import tempfile

import bpy
from mathutils import Vector


def clear_scene():
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)


def get_args():
    argv = sys.argv
    if "--" not in argv:
        raise ValueError(
            "Missing '--' arguments. Expected: input.vox output.fbx reference_model target_resolution [angle_deg]"
        )

    args = argv[argv.index("--") + 1 :]

    if len(args) < 4:
        raise ValueError(
            "Expected at least: input.vox output.fbx reference_model target_resolution [angle_deg]"
        )

    input_vox = os.path.abspath(args[0])
    output_fbx = os.path.abspath(args[1])
    reference_model = os.path.abspath(args[2])
    target_resolution = int(args[3])
    angle_deg = float(args[4]) if len(args) > 4 else 5.0

    if not os.path.exists(input_vox):
        raise FileNotFoundError(f"VOX input does not exist: {input_vox}")

    if not os.path.exists(reference_model):
        raise FileNotFoundError(f"Reference model does not exist: {reference_model}")

    if target_resolution <= 0:
        raise ValueError("target_resolution must be > 0")

    return input_vox, output_fbx, reference_model, target_resolution, angle_deg


def get_mesh_objects():
    return [obj for obj in bpy.context.scene.objects if obj.type == "MESH"]


def select_only(obj):
    bpy.ops.object.select_all(action="DESELECT")
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj


def apply_object_transforms(obj):
    select_only(obj)
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)


def import_reference_model(path: str):
    before = set(get_mesh_objects())

    ext = os.path.splitext(path)[1].lower()
    if ext == ".glb" or ext == ".gltf":
        bpy.ops.import_scene.gltf(filepath=path)
    elif ext == ".fbx":
        bpy.ops.import_scene.fbx(filepath=path)
    elif ext == ".obj":
        bpy.ops.wm.obj_import(filepath=path)
    else:
        raise ValueError(f"Unsupported reference format: {ext}")

    after = set(get_mesh_objects())
    imported = list(after - before)

    if not imported:
        raise RuntimeError("No mesh objects found after importing reference model.")

    return imported


def import_vox(input_path: str, voxel_size: float):
    before = set(get_mesh_objects())

    result = bpy.ops.import_scene.vox(
        filepath=input_path,
        import_cameras=False,
        import_hierarchy=False,
        voxel_size=voxel_size,
        max_texture_size=2048,
        import_material_props=False,
        material_mode="MAT_AS_TEX",
        meshing_type="GREEDY",
        voxel_hull=True,
        join_models=True,
    )
    print("Import result:", result)

    after = set(get_mesh_objects())
    imported = list(after - before)

    if not imported:
        raise RuntimeError("No mesh objects found after VOX import.")

    return imported


def get_world_bbox(objects):
    min_x = min_y = min_z = float("inf")
    max_x = max_y = max_z = float("-inf")

    found = False

    for obj in objects:
        if obj.type != "MESH":
            continue

        for corner in obj.bound_box:
            world_corner = obj.matrix_world @ Vector(corner)

            min_x = min(min_x, world_corner.x)
            min_y = min(min_y, world_corner.y)
            min_z = min(min_z, world_corner.z)

            max_x = max(max_x, world_corner.x)
            max_y = max(max_y, world_corner.y)
            max_z = max(max_z, world_corner.z)

            found = True

    if not found:
        raise RuntimeError(
            "Could not compute bounding box; no valid mesh geometry found."
        )

    size_x = max_x - min_x
    size_y = max_y - min_y
    size_z = max_z - min_z

    center_x = (min_x + max_x) / 2.0
    center_y = (min_y + max_y) / 2.0
    center_z = (min_z + max_z) / 2.0

    return {
        "min": (min_x, min_y, min_z),
        "max": (max_x, max_y, max_z),
        "size": (size_x, size_y, size_z),
        "center": (center_x, center_y, center_z),
    }


def set_origin_to_geometry(objects):
    for obj in objects:
        select_only(obj)
        bpy.ops.object.origin_set(type="ORIGIN_GEOMETRY", center="BOUNDS")


def move_objects_by(objects, dx, dy, dz):
    for obj in objects:
        obj.location.x += dx
        obj.location.y += dy
        obj.location.z += dz


def scale_objects_uniform(objects, scale_factor):
    for obj in objects:
        obj.scale *= scale_factor


def get_uniform_scale_factor(ref_size, vox_size):
    axis_ratios = [
        ref_axis / vox_axis
        for ref_axis, vox_axis in zip(ref_size, vox_size)
        if ref_axis > 0 and vox_axis > 0
    ]

    if not axis_ratios:
        raise RuntimeError("Invalid bounding box size while matching scale.")

    axis_ratios.sort()
    return axis_ratios[len(axis_ratios) // 2]


def match_voxel_scale_to_reference(voxel_objects, reference_objects):
    # Apply scale so bound_box is trustworthy
    for obj in reference_objects + voxel_objects:
        apply_object_transforms(obj)

    ref_bbox = get_world_bbox(reference_objects)
    vox_bbox = get_world_bbox(voxel_objects)

    ref_size = ref_bbox["size"]
    vox_size = vox_bbox["size"]

    scale_factor = get_uniform_scale_factor(ref_size, vox_size)
    print(f"Reference size: {ref_size}")
    print(f"Voxel size before scale: {vox_size}")
    print(f"Uniform scale factor: {scale_factor}")

    scale_objects_uniform(voxel_objects, scale_factor)

    for obj in voxel_objects:
        apply_object_transforms(obj)

    # Recompute and align centres
    ref_bbox = get_world_bbox(reference_objects)
    vox_bbox = get_world_bbox(voxel_objects)

    ref_center = ref_bbox["center"]
    vox_center = vox_bbox["center"]

    dx = ref_center[0] - vox_center[0]
    dy = ref_center[1] - vox_center[1]
    dz = ref_center[2] - vox_center[2]

    move_objects_by(voxel_objects, dx, dy, dz)

    for obj in voxel_objects:
        apply_object_transforms(obj)

    print("Voxel mesh scaled and aligned to reference model.")


def delete_objects(objects):
    bpy.ops.object.select_all(action="DESELECT")
    for obj in objects:
        obj.select_set(True)
    bpy.ops.object.delete(use_global=False)


def planar_decimate_mesh_objects(objects, angle_deg: float):
    angle_limit = math.radians(angle_deg)

    for obj in objects:
        select_only(obj)

        mod = obj.modifiers.new(name="PlanarDecimate", type="DECIMATE")
        mod.decimate_type = "DISSOLVE"
        mod.angle_limit = angle_limit
        mod.delimit = {"UV"}

        bpy.ops.object.modifier_apply(modifier=mod.name)
        obj.select_set(False)

    print(
        f"Applied planar decimate to {len(objects)} mesh object(s) with angle {angle_deg}°"
    )


def save_generated_images(texture_dir: str):
    os.makedirs(texture_dir, exist_ok=True)

    saved_count = 0

    for image in bpy.data.images:
        if image.source != "GENERATED":
            continue

        safe_name = bpy.path.clean_name(image.name) or "voxel_texture"
        image_path = os.path.join(texture_dir, f"{safe_name}.png")
        image.filepath_raw = image_path
        image.file_format = "PNG"
        image.save()
        image.reload()
        saved_count += 1

    print(f"Saved {saved_count} generated texture(s) to: {texture_dir}")


def export_fbx(output_path: str):
    output_dir = os.path.dirname(output_path)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)

    texture_dir = tempfile.mkdtemp(prefix="voxel-fbx-textures-")

    try:
        save_generated_images(texture_dir)
        print("About to export to:", output_path)

        result = bpy.ops.export_scene.fbx(
            filepath=output_path,
            use_selection=False,
            apply_scale_options="FBX_SCALE_UNITS",
            bake_space_transform=False,
            path_mode="COPY",
            embed_textures=True,
        )

        print("Export result:", result)
        print("Exists after export:", os.path.exists(output_path))

        if not os.path.exists(output_path):
            raise RuntimeError(f"FBX export did not create file: {output_path}")

        print("Exported:", output_path)
    finally:
        shutil.rmtree(texture_dir, ignore_errors=True)


def main():
    input_vox, output_fbx, reference_model, target_resolution, angle_deg = get_args()

    print("VOX input:", input_vox)
    print("Output:", output_fbx)
    print("Reference:", reference_model)
    print("Target resolution:", target_resolution)
    print("Angle:", angle_deg)

    clear_scene()

    reference_objects = import_reference_model(reference_model)
    ref_bbox = get_world_bbox(reference_objects)
    ref_max = max(ref_bbox["size"])
    if ref_max <= 0:
        raise RuntimeError("Reference model has an invalid bounding box.")

    voxel_size = ref_max / target_resolution
    print("Reference size:", ref_bbox["size"])
    print("Derived voxel size:", voxel_size)

    voxel_objects = import_vox(input_vox, voxel_size)

    match_voxel_scale_to_reference(voxel_objects, reference_objects)

    delete_objects(reference_objects)

    voxel_objects = get_mesh_objects()
    planar_decimate_mesh_objects(voxel_objects, angle_deg)

    export_fbx(output_fbx)


if __name__ == "__main__":
    main()
