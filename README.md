# VantHoffFitting



## Try without installation

Click this [link](https://notebooks.mpcdf.mpg.de/binder/v2/git/https%3A%2F%2Fgitlab.mpcdf.mpg.de%2Fjabuller%2Fvanthofffitting/HEAD?labpath=examples%2Fpipeline_example.ipynb) to try the `pipeline_example.ipynb` notebook in a computational cloud environment.  

You can either analyze the data sets found in `examples/mock_data/` or upload your own.  The interactive session is only temporary and files will be deleted after termination (File -> Shut Down).  

**Important:** Please shut down JupyterLab properly after use via the drop-down menu (File -> Shut Down) to free resources for other users.  



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



### Data fitting

The function `fit_data` is used to find the best model that fits the data:
```julia
model, spline_parameters = fit_data(data)
```
It outputs a string `model` and an array `spline_parameters`, where the former contains information about the model that best fits the data (either "linear" or "reciprocal") and the latter gives the associated fit parameters.  These can then be used to evaluate the following built-in functions:
```julia
ln_K(T, spline_parameters, model) # logarithm of equilibrium constant
ΔC_p(T, spline_parameters, model) # isobaric heat capacity
ΔH(T, spline_parameters, model) # enthalpy
ΔS(T, spline_parameters, model) # entropy
ΔG(T, spline_parameters, model) # Gibbs free energy
```
