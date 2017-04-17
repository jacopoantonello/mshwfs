MSHWFS - Modal-Shack-Hartmann-Wavefront-Sensor toolbox
******************************************************

MATLAB toolbox to estimate the wavefront from Shack-Hartmann wavefront sensor
(SHWFS) images. This toolbox implements the modal-based wavefront
reconstruction method described in Section 1.3.2 of [A2014]_.


Main Features
=============

* automatic calibration from a given SHWFS reference image
* handles an arbitrary arrangement and number of subapertures
* estimates an arbitrary number of Zernike modes
* computes the definite integrals of the gradients of the Zernike modes within
  each subaperture
* contains an example with real SHWFS images 


Requirements
============

* MATLAB
* a SHWFS reference image for calibration


Usage
=====

To perform the calibration, open ``calibration.m``,

::

    >> cd examples/
    >> edit calibration.m

You can run the calibration using the example SHWFS reference image found in
``examples/data/sh_flat.mat``. To use your own SHWFS reference image:

* adjust the parameters for your lenslet array
* replace ``load sh_flat_bg.mat`` with your background reference image (dark frame).
* replace ``load sh_flat.mat`` with your SHWFS reference image, i.e., an image taken with your SHWFS when no aberration is present
* run the script adjusting the parameters if necessary. For example, you may want to disable some subapertures. You can do this by zeroing the corresponding pixels in the SHWFS reference image.

Once the calibration is complete, you can estimate the wavefront from an
arbitrary SHWFS image. An example is provided in ``reconstruction.m``. To use
your own images, just replace ``load img.mat``.


References
==========

 .. [A2014] J. Antonello, "Optimisation-based wavefront sensorless adaptive optics for microscopy," Ph.D. thesis, Delft University of Technology (2014).  L1_

 .. _L1: http://resolver.tudelft.nl/uuid:f98b3b8f-bdb8-41bb-8766-d0a15dae0e27

 .. [W1] http://www.antonello.org/code.php
