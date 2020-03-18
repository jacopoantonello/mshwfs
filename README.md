# MSHWFS - Modal-Shack-Hartmann-Wavefront-Sensor toolbox
MATLAB toolbox to estimate wavefronts from Shack-Hartmann wavefront sensor (SHWFS) images. This toolbox implements the modal-based wavefront reconstruction method described in Section 1.3.2 of [(1)]. It also contains code to generate and plot Zernike polynomials as defined by Noll [(2)].

## Main Features
- automatic calibration from a given SHWFS reference image
- handles an arbitrary arrangement and number of subapertures
- estimates an arbitrary number of Zernike modes
- computes the definite integrals of the gradients of the Zernike modes within each subaperture
- contains an example with real SHWFS images 

## Requirements
- MATLAB
- a SHWFS reference image for calibration

## Usage
To perform the calibration, open `calibration.m`,
```
    >> cd examples/
    >> edit calibration.m
```
You can run the calibration using the example SHWFS reference image found in
`examples/data/sh_flat.mat`. To use your own SHWFS reference image:
- adjust the parameters for your lenslet array
- replace `load sh_flat_bg.mat` with your background reference image (dark frame).
- replace `load sh_flat.mat` with your SHWFS reference image, i.e., an image taken with your SHWFS when no aberration is present
- run the script adjusting the parameters if necessary. For example, you may want to disable some subapertures. You can do this by zeroing the corresponding pixels in the SHWFS reference image.

Once the calibration is complete, you can estimate the wavefront from an arbitrary SHWFS image. An example is provided in `reconstruction.m`. To use your own images, just replace `load img.mat`.

## References
[(1)] J. Antonello, "Optimisation-based wavefront sensorless adaptive optics for microscopy," Ph.D. thesis, Delft University of Technology (2014)
[(2)] Robert J. Noll, "Zernike polynomials and atmospheric turbulence*," J. Opt. Soc. Am. 66, 207-211 (1976)


[(1)]: http://antonello.org/phd-thesis.pdf
[(2)]: https://doi.org/10.1364/JOSA.66.000207
