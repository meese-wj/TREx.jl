export construct_lattice!, num_sites, site_index, nearest_neighbors, parameters

"""
    abstract type AbstractLattice end

The `supertype` for all `Type`s of lattices one can dream of.

# Required Interface Methods

One must define the following `methods` for each new (non-`abstract`) `AbstractLattice`:

- [`Base.size`](@ref)
- [`construct_lattice!`](@ref)
- [`num_sites`](@ref)
- [`site_index`](@ref)
- [`nearest_neighbors`](@ref)
- [`parameters`](@ref)

# Default Interface Methods

The following represent the default `methods` for `AbstractLattice`s. One may still overload
them for any peculiar `subtype`.

- [`DrWatson.savename`](@ref)
"""
abstract type AbstractLattice end

# Required interface methods with MethodError defaults
"""
    construct_lattice!(::AbstractLattice)

Build a lattice and its geometry. Meant to be used in a constructor.
"""
construct_lattice!( latt::AbstractLattice ) = throw(MethodError(construct_lattice!, latt))
"""
    num_sites(::AbstractLattice)

Return the number of sites that an [`AbstractLattice`](@ref) contains.

# Example

```jldoctest
julia> latt = Lattices.CubicLattice2D(4, 4);

julia> Lattices.num_sites(latt)
16
```
"""
num_sites( latt::AbstractLattice ) = throw(MethodError(num_sites, latt))
"""
    site_index(::AbstractLattice, indices::itr)

Calculate the flattened index from an iterable set of `indices` in an [`AbstractLattice`](@ref).

# Example

```jldoctest
julia> latt = Lattices.CubicLattice2D(4, 4);

julia> Lattices.site_index(latt, (1, 2))
5
```
"""
site_index( latt::AbstractLattice, indices ) = throw(MethodError(site_index, latt, indices))
"""
    nearest_neighbors(::AbstractLattice, site)

Return the set of `nearest_neighbors` for a given `site` in the [`AbstractLattice`](@ref).

# Example

```jldoctest
julia> latt = Lattices.CubicLattice2D(4, 4);

julia> Lattices.nearest_neighbors(latt, 1)
4-element view(::Matrix{Int32}, 1, :) with eltype Int32:
 13
  4
  2
  5
```
"""
nearest_neighbors( latt::AbstractLattice, site ) = throw(MethodError(nearest_neighbors, latt, site))
"""
    parameters(::AbstractLattice)

Return the `parameters` used to define the [`AbstractLattice`](@ref).

# Example

```jldoctest
julia> latt = Lattices.CubicLattice2D(4, 4);

julia> Lattices.parameters(latt)
TRExMC.Models.Lattices.CubicLattice2DParams(4, 4)
```
"""
parameters(latt::AbstractLattice) = throw(MethodError(parameters, latt))