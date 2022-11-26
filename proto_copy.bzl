def _proto_copy_impl(ctx):
    generated = ctx.attr.src[OutputGroupInfo].go_generated_srcs.to_list()
    substitutions = {
        "@@FROM@@": " ".join([i.path for i in generated]),
        "@@TO@@": ctx.attr.dir,
    }
    out = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = out,
        substitutions = substitutions,
        is_executable = True,
    )
    runfiles = ctx.runfiles(files = generated)
    return [
        DefaultInfo(
            runfiles = runfiles,
            executable = out,
        ),
    ]

_proto_copy = rule(
    implementation = _proto_copy_impl,
    executable = True,
    attrs = {
        "dir": attr.string(),
        "src": attr.label(),
        "_template": attr.label(
            default = "//:proto-copy.bash",
            allow_single_file = True,
        ),
    },
)

def proto_copy(name, **kwargs):
    if not "dir" in kwargs:
        dir = native.package_name()
        kwargs["dir"] = dir

    _proto_copy(name = name, **kwargs)
