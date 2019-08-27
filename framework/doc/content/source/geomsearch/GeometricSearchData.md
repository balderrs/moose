# GeometricSearchData

- Sometimes information needs to be exchanged between disconnected pieces of mesh.
- Examples include:
    - Mechanical Contact
    - Gap Heat Conduction
    - Radiation
    - Constraints
    - Mesh Tying
- The Geometric Search system allows an application to track evolving geometric relationships.
- Currently, this entails two main capabilities: [`NearestNodeLocator`](/NearestNodeLocator.md) and [`PenetrationLocator`](/PenetrationLocator.md).
- Both of the capabilities work in parallel and with both Parallel- and Serial-Mesh.
- Locators can be requested using four different methods on the `GeometricSearchData` API:
    - `getQuadraturePenetrationLocator`
    - `getPenetrationLocator`
    - `getQuadratureNearestNodeLocator`
    - `getNearestNodeLocator`
- The `*Quadrature*` based methods should be used within quadrature-point based objects like:
    - [`Materials`](Materials/index.md) e.g. the `HeatConduction` module's `GapConductance` object
    - [`IntegratedBCs`](syntax/BCs/index.md) e.g. the `HeatConduction` module's `GapHeatTransfer` object
    - [Elemental `AuxKernels`](AuxKernels/index.md) e.g. the elemental versions of [`GapValueAux`](/GapValueAux.md), [`NearestNodeDistanceAux`](/NearestNodeDistanceAux.md), and [`PenetrationAux`](/PenetrationAux.md)
- The non-quadrature based methods should be used for nodal objects such as:
    - [`NodeFaceConstraints`](Constraints/index.md) e.g. the `Contact` module's `MechanicalContactConstrant` object
    - [Nodal `AuxKernels`](AuxKernels/index.md) e.g. the nodal versions of [`GapValueAux`](/GapValueAux.md), [`NearestNodeDistanceAux`](/NearestNodeDistanceAux.md), and [`PenetrationAux`](/PenetrationAux.md)
- geometric search objects like [`NearestNodeLocator`](/NearestNodeLocator.md) and [`PenetrationLocator`](/PenetrationLocator.md) should hold to their geometric purpose and **not** call algebraic APIs like `FEProblemBase::prepare` which will query `libMesh::DofObject` information. This information may or may not have been initialized at the time that geometric search objects are being updated, so any query attempt may result in failed assertions or segmentaton faults.