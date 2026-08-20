
Mostar v1.0.5
- Improved HTML report, added detailed description to each segment, as well visual enhancements.
- Added a new tool, Integron Finder, run using --integron flag
- Various small bug fixes and improvements 

Mostar v1.0.4
- Fixed `NotImplementedError` crash in `generate_maps.py` when generating
  circular maps for assemblies with ICE hits not matching a specific contig
  (Biopython deliberately disables `SeqRecord.__eq__`; changed `==` to `is`
  for the intended object-identity check). This bug was present in the
  published v1.0.3 release and affected multi-contig assemblies with
  unmatched ICE annotations.

Mostar v1.0.3 
- Dockerfile: added missing `pip install --no-deps .` step (MOSTAR was
  never actually installed in the published image)
- Dockerfile: proper `conda activate` via entrypoint.sh instead of bare PATH
- Dockerfile: added `amrfinder -u` (AMR database was never downloaded)
- Dockerfile: added `msf_data install --target /opt/macsy-models CONJScan`
- Pinned `bakta=1.11.4`, `pyhmmer<0.11`, `hmmer=3.4`, `alive-progress=3.0.1`
- Fixed MacSyFinder call: added `--models-dir`, corrected to
  `CONJScan/Chromosome all`
- Fixed default Kraken2 confidence threshold (was set too strict, causing
  silent zero-classification results)
- Added `--force` flag to Bakta call

Mostar v1.0.2
- Small bug fixes and improvements

Mostar v1.0.1
- Small bug fixes and improvements 

Mostar v1.0.0 
- Initial release 