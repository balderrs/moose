//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "FVTimeKernel.h"

/**
 * Computes the momentum time derivative for the weakly compressible formulation of the momentum
 * equation, using functor material properties. Only one spatial component is included.
 */
class WCNSFVMomentumTimeDerivative : public FVTimeKernel
{
public:
  static InputParameters validParams();
  WCNSFVMomentumTimeDerivative(const InputParameters & params);

protected:
  ADReal computeQpResidual() override;

  const Moose::Functor<ADReal> & _rho;
  const Moose::Functor<ADReal> & _rho_dot;
};
