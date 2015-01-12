/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef CLOSEPACKIC_H
#define CLOSEPACKIC_H

// MOOSE includes
#include "SmoothCircleBaseIC.h"

// Forward declarations
class ClosePackIC;

template<>
InputParameters validParams<ClosePackIC>();

/**
 * An InitialCondition for initializing phase variable in close packed circles/spheres pattern
 */
class ClosePackIC : public SmoothCircleBaseIC
{
public:

  /**
   * Class constructor
   * @param name Name of the InitialCondition object
   * @param parameters Input parameters for this object
   */
  ClosePackIC(const std::string & name, InputParameters parameters);

  /**
   * Destructor
   */
  virtual ~ClosePackIC(){};

  /**
   * Does nothing, but required by the base class
   *
   * The radius are populated in the computeCircleCenters
   */
  virtual void computeCircleRadii();

  /**
   * Compute the close packed centers and radii
   */
  virtual void computeCircleCenters();


protected:

  /// User-supplied circle radius
  Real _radius;
};

#endif //CLOSEPACKIC_H
