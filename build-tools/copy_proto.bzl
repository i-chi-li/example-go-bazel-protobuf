def _as_path(p, is_windows):
    if is_windows:
        return p.replace("/", "\\")
    else:
        return p

def _copy_proto_impl(ctx):
    is_windows = ctx.attr.is_windows

    generated_files = ctx.attr.src[OutputGroupInfo].go_generated_srcs.to_list()
    src_dir = _as_path(generated_files[0].dirname, is_windows)
    dest_dir = _as_path(ctx.attr.dst, is_windows)

    substitutions = {
        "@@FROM_DIR@@": src_dir,
        "@@TO_DIR@@": dest_dir,
    }

    ext = ".sh"
    template = ctx.file._template_shell
    if is_windows:
        ext = ".bat"
        template = ctx.file._template_cmd

    out = ctx.actions.declare_file(ctx.label.name + ext)

    ctx.actions.expand_template(
        template = template,
        output = out,
        substitutions = substitutions,
        is_executable = True,
    )

    return [
        DefaultInfo(
            runfiles = ctx.runfiles(files = generated_files),
            executable = out,
        ),
    ]

_copy_proto = rule(
    implementation = _copy_proto_impl,
    executable = True,
    attrs = {
        "src": attr.label(),
        "dst": attr.string(),
        "is_windows": attr.bool(),
        "_template_shell": attr.label(
            default = "//build-tools:copy_proto.bash",
            allow_single_file = True,
        ),
        "_template_cmd": attr.label(
            default = "//build-tools:copy_proto.bat",
            allow_single_file = True,
        ),
    },
)

def copy_proto(name, **kwargs):
    _copy_proto(
        name = name,
        # select は、上の default には、記載できない
        is_windows = select({
            "@bazel_tools//src/conditions:host_windows": True,
            "//conditions:default": False,
        }),
        **kwargs
    )
