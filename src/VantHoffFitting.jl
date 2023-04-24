# Code for fitting van t' Hoff plots and extracting various thermodynamic potentials.  
# version 1.0 (28/09/2021)
# Jakob Tómas Bullerjahn (jabuller@biophys.mpg.de)

# Please read and cite the associated publication: 
# J. T. Bullerjahn and S. Hanson, "Robust analysis of the thermodynamic properties of temperature-sensing molecules", in preparation. 



module VantHoffFitting

export
        # Thermodynamics:
        R, # gas constant
        ln_K, # equilibrium constant
        ΔG, # free energy
        ΔH, # enthalpy
        ΔS, # entropy
        ΔC_p, # heat capacity

        # Data fitting:
        fit_data

using Base.Threads
using BlackBoxOptim
using DelimitedFiles
using LaTeXStrings
using Plots
using ProgressMeter

include("cubic_spline_functions.jl")
include("thermodynamic_functions.jl")
include("data_fitting_functions.jl")

end
