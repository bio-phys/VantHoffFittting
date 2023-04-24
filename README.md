# VantHoffFitting



## Installation

The package is written in the open-source programming language [Julia](https://github.com/JuliaLang/julia), which can be downloaded from their [webpage](https://julialang.org/downloads/#download_julia).  

Currently, the package is not in a registry.  It must therefore be added by specifying a URL to the repository:
```julia
using Pkg; Pkg.add(url="https://github.com/bio-phys/VantHoffFitting")
```
Users of older versions of Julia may need to wrap the contents of the brackets with `PackageSpec()`.  



## Usage

### Importing data

The data should be of the type `Array{Float64,2}`, where the first column contains the temperatures `T` (in *K*) and the second column the logarithm of the equilibrium constant `ln_K` (dimensionless).  An optional third columns should contain associated uncertainties `∆ln_K` (dimensionless).  Users can read their data in from file as follows:
```julia
using DelimitedFiles

data = readdlm(file_name)
```
