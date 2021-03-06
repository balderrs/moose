//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "GeneralReporter.h"
#include "AdaptiveImportanceSampler.h"

/**
 * AdaptiveMonteCarloDecision will help make sample accept/reject decisions in adaptive Monte Carlo
 * schemes.
 */
class AdaptiveMonteCarloDecision : public GeneralReporter
{
public:
  static InputParameters validParams();
  AdaptiveMonteCarloDecision(const InputParameters & parameters);
  virtual void initialize() override {}
  virtual void finalize() override {}
  virtual void execute() override;

protected:
  /// Model output value from SubApp
  const std::vector<Real> & _output_value;

  /// Modified value of model output by this reporter class
  std::vector<Real> & _output_required;

  /// Model input data that is uncertain
  std::vector<Real> & _inputs;

private:
  /// Track the current step of the main App
  const int & _step;

  /// The adaptive Monte Carlo sampler
  Sampler & _sampler;

  const AdaptiveImportanceSampler * const _ais;

  /// Ensure that the MCMC algorithm proceeds in a sequential fashion
  int _check_step;

  /// Storage for previously accepted input values. This helps in making decision on the next proposed inputs.
  std::vector<Real> _prev_val;

  /// Storage for previously accepted output value.
  Real _prev_val_out;
};
