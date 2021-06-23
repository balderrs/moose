inlet_vel = 1.2
rho_in = 0.8719748696
H_in = 4.0138771448e+05

mass_flux = ${fparse inlet_vel * rho_in}
enthalpy_flux = ${fparse inlet_vel * rho_in * H_in}

outlet_pressure = 0.9e5

[GlobalParams]
  fp = fp
[]

[Debug]
   show_material_props = true
[]

[Mesh]
  [file]
    type = FileMeshGenerator
    file = subsonic_nozzle.e
  []
[]

[Modules]
  [FluidProperties]
    [fp]
      type = IdealGasFluidProperties
    []
  []
[]

[Variables]
  [rho]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 0.8719748696
  []

  [rho_u]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 1e-4
    outputs = none
  []

  [rho_v]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    outputs = none
  []

  [rho_E]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = 2.5e5
  []
[]

[FVKernels]
  # Mass conservation
  [mass_time]
    type = FVTimeKernel
    variable = rho
  []

  [mass_advection]
    type = CNSFVMassHLLC
    variable = rho
  []

  # Momentum x conservation
  [momentum_x_time]
    type = FVTimeKernel
    variable = rho_u
  []

  [momentum_x_advection]
    type = CNSFVMomentumHLLC
    variable = rho_u
    momentum_component = x
  []

  # Momentum y conservation
  [momentum_y_time]
    type = FVTimeKernel
    variable = rho_v
  []

  [momentum_y_advection]
    type = CNSFVMomentumHLLC
    variable = rho_v
    momentum_component = y
  []

  # Fluid energy conservation
  [fluid_energy_time]
    type = FVTimeKernel
    variable = rho_E
  []

  [fluid_energy_advection]
    type = CNSFVFluidEnergyHLLC
    variable = rho_E
  []
[]

[FVBCs]
  ## inflow stagnation boundaries
  [mass_stagnation_inflow]
    type = FVNeumannBC
    variable = rho
    value = ${mass_flux}
    boundary = left
  []

  [momentum_x_stagnation_inflow]
    type = CNSFVHLLCMomentumImplicitBC
    variable = rho_u
    momentum_component = x
    boundary = left
  []

  [momentum_y_stagnation_inflow]
    type = CNSFVHLLCMomentumImplicitBC
    variable = rho_v
    momentum_component = y
    boundary = left
  []

  [fluid_energy_stagnation_inflow]
    type = FVNeumannBC
    variable = rho_E
    value = ${enthalpy_flux}
    boundary = left
  []

  ## outflow implicit conditions
  [mass_outflow]
    type = CNSFVHLLCMassImplicitBC
    variable = rho
    boundary = right
  []

  # outflow explicit pressure boundary condition
  [momentum_x_outflow]
    type = CNSFVHLLCMomentumSpecifiedPressureBC
    variable = rho_u
    momentum_component = x
    specified_pressure_function = ${outlet_pressure}
    boundary = right
  []

  [momentum_y_outflow]
    type = CNSFVHLLCMomentumSpecifiedPressureBC
    variable = rho_v
    momentum_component = y
    specified_pressure_function = ${outlet_pressure}
    boundary = right
  []

  [fluid_energy_outflow]
    type = CNSFVHLLCFluidEnergyImplicitBC
    variable = rho_E
    boundary = right
  []

  # wall conditions
  [momentum_x_pressure_wall]
    type = CNSFVMomImplicitPressureBC
    variable = rho_u
    momentum_component = x
    boundary = wall
  []

  [momentum_y_pressure_wall]
    type = CNSFVMomImplicitPressureBC
    variable = rho_v
    momentum_component = y
    boundary = wall
  []
[]

[AuxVariables]
  [Ma]
    family = MONOMIAL
    order = CONSTANT
  []

  [p]
    family = MONOMIAL
    order = CONSTANT
  []

  [Ma_layered]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[UserObjects]
  [layered_Ma_UO]
    type = LayeredAverage
    variable = Ma
    num_layers = 100
    direction = x
  []
[]

[AuxKernels]
  [Ma_aux]
    type = NSMachAux
    variable = Ma
    fluid_properties = fp
    use_material_properties = true
  []

  [p_aux]
    type = ADMaterialRealAux
    variable = p
    property = p
  []

  [Ma_layered_aux]
    type = SpatialUserObjectAux
    variable = Ma_layered
    user_object = layered_Ma_UO
  []
[]

[Materials]
  [var_mat]
    type = ConservedVarValuesMaterial
    rho = rho
    rhou = rho_u
    rhov = rho_v
    rho_et = rho_E
  []

  [fluid_props]
    type = GeneralFluidProps
    porosity = 1
    characteristic_length = 1
  []

  [sound_speed]
    type = SoundspeedMat
  []
[]

[Postprocessors]
  [outflow_Ma]
    type = SideAverageValue
    variable = Ma
    boundary = right
  []

  [outflow_pressure]
    type = SideAverageValue
    variable = p
    boundary = right
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  []
[]

[Executioner]
  type = Transient
  #end_time = 100
  num_steps = 10
  dt = 1e-2
  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[VectorPostprocessors]
  [Ma_layered]
    type = LineValueSampler
    variable = Ma_layered
    start_point = '0 0 0'
    end_point = '3 0 0'
    num_points = 100
    sort_by = x
  []
[]

[Outputs]
  exodus = true
[]
