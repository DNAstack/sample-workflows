# VCF stats via DRS ID

This workflow will download a VCF file using a DRS URL. It will then run bcftools stats on that VCF and output the stats file.

Test inputs may be found in [inputs.json](inputs.json).


## Docker images

Docker image definitions may be found in DNAstack's [public image repository](https://github.com/dnastack/bioinformatics-public-docker-images).

Required docker images have been pushed to the public Google container registry (gcr.io/dnastack-pub-container-store).
