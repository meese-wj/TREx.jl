using TREx
using Documenter

DocMeta.setdocmeta!(TREx, :DocTestSetup, :(using TREx); recursive=true)

makedocs(;
    modules=[TREx],
    authors="W. Joe Meese <meese022@umn.edu> and contributors",
    repo="https://github.com/meese-wj/TREx.jl/blob/{commit}{path}#{line}",
    sitename="TREx.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://meese-wj.github.io/TREx.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/meese-wj/TREx.jl",
    devbranch="main",
)
