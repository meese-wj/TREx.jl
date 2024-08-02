using TRExMC
using Documenter

DocMeta.setdocmeta!(TRExMC, :DocTestSetup, :(using TRExMC); recursive=true)

repo = Documenter.Remotes.GitHub("meese-wj", "TRExMC.jl")

makedocs(;
    modules=[TRExMC],
    authors="W. Joe Meese <meese022@umn.edu> and contributors",
    repo = repo,
    # repo="https://github.com/meese-wj/TRExMC.jl/blob/{commit}{path}#{line}",
    sitename="TRExMC.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://meese-wj.github.io/TRExMC.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    warnonly = [:missing_docs],
)

deploydocs(;
    repo = "github.com/$(repo.user)/$(repo.repo)",
    devbranch="main",
)
