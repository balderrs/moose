# Transfers System

When running simulations that contain [MultiApps](/MultiApps/index.md)---simulations running
other sub-simulations---it is often required to move data to and from the sub-applications. Transfer
objects in MOOSE are designed for this purpose.

!alert note
Prior to understanding Transfers it is important to grasp the idea of [MultiApps](/MultiApps/index.md) first, so please
refer to the [MultiApps](/MultiApps/index.md) documentation for additional information.

## Example Transfer

Assuming that the concept of [MultiApps](/MultiApps/index.md) is understood, Transfers are best understood via an example
problem. First, consider a "master" simulation that is solving the transient diffusion equation. This
master simulation also includes two "sub" applications that rely on the average value of the unknown
from the master application.

### The "master" Simulation

[transfers-master-multiapps] is an input file snippet showing the [MultiApps](/MultiApps/index.md) block that includes a
[TransientMultiApp](/TransientMultiApp.md), this sub-application will execute along with the master
(at the end of each timestep) as time progresses.

!listing test/tests/transfers/multiapp_postprocessor_to_scalar/master.i
         block=MultiApps id=transfers-master-multiapps
         caption=The [MultiApps](/MultiApps/index.md) block of the "master" application that contains two sub-application
                 that solves along with the master as time progresses.

For this example, the sub-applications require that the average from the master in the form of a
scalar AuxVariable, see the [AuxVariables] documentation for further information. Therefore the
master will transfer the average value (computed via the
[ElementAverageValue](/ElementAverageValue.md) Postprocessor) to a scalar AuxVariable on each
sub-application. As shown in [transfers-master-transfers], the
[MultiAppPostprocessorToAuxScalarTransfer](/MultiAppPostprocessorToAuxScalarTransfer.md) is provided
for this purpose.

!listing test/tests/transfers/multiapp_postprocessor_to_scalar/master.i
         block=Transfers
         id=transfers-master-transfers
         caption=The Transfers block of the "master" application that contains a Transfer of a
                     Postprocessor to a scalar AuxVariable on sub-applications.

### The "sub" Simulations

For this simple example the sub-application must contain an appropriate AuxVariable to receiving
the Postprocessor value from the master application.

!listing test/tests/transfers/multiapp_postprocessor_to_scalar/sub.i
         block=AuxVariables
         id=transfers-sub
         caption=The AuxVariables block of the "sub" application that contains a scalar that the
                     master application will update.

The sub-applications do not have any "knowledge" of the master application, and simply perform
calculations that utilize the scalar variable, regardless of how this scalar is computed. This
approach allows the sub-application input file to run in union of independent from the master without
modification, which is useful for development and testing.

## Available Transfer Objects

The following is a complete list of the available Transfer objects, each links to a page with further
details.

!syntax list /Transfers objects=True actions=False subsystems=False

!syntax list /Transfers objects=False actions=False subsystems=True

!syntax list /Transfers objects=False actions=True subsystems=False
