const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(
    .{
        .name = "cimgui",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const cimgui_path = "lib/cimgui/";
    const cimgui_gen_out_path = cimgui_path ++ "generator/output/";
    const imgui_path = cimgui_path ++ "imgui/";
    const imgui_backend_path = imgui_path ++ "backends/";

    exe.addIncludePath(std.Build.LazyPath { .path = imgui_path });
    exe.addIncludePath(std.Build.LazyPath { .path = imgui_backend_path });
    exe.addIncludePath(std.Build.LazyPath { .path = cimgui_gen_out_path });
    exe.addIncludePath(std.Build.LazyPath { .path = cimgui_path });

    exe.addCSourceFiles(
        &[_][]const u8{
            imgui_path ++ "imgui.cpp",
            imgui_path ++ "imgui_demo.cpp",
            imgui_path ++ "imgui_draw.cpp",
            imgui_path ++ "imgui_tables.cpp",
            imgui_path ++ "imgui_widgets.cpp",
            imgui_backend_path ++ "imgui_impl_sdl2.cpp",
            imgui_backend_path ++ "imgui_impl_sdlrenderer2.cpp",
            cimgui_path ++ "cimgui.cpp",
        },
        &[_][]const u8{
            "-O2",
            "-ffunction-sections",
            "-fdata-sections",
            "-DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1",
            "-DIMGUI_IMPL_API=extern \"C\" ",
            "-DIMGUI_IMPL_OPENGL_LOADER_GL3W",
            "-Dcimgui_EXPORTS",
        },
    );

    exe.linkSystemLibrary("SDL2");
    exe.linkLibC();
    exe.linkLibCpp();

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args|
        run_cmd.addArgs(args);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
