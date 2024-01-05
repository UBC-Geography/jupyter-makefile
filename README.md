# Overview

This repository includes a simple Makefile that can be used to create Jupyter kernels in UBC LT's Open JupyterHub using standard environment/dependency files, like environment.yml, requirements.txt, and install.R. Kernels created with this Makefile are built using a conda environment that is stored in the user directory. This ensures that the kernel persists across sessions and that any packages installed in the kernel's environment will not conflict with packages already installed in Open Jupyter's base environment.

## Install

1. Start a new terminal session in your JupyterHub environment and create a project directory. The directory name should not inlcude any spaces.

```bash
$ mkdir <project_directory>
```

2. Enter your newly created project directory.

```bash
$ cd <project_directory>
```

3. Copy the Makefile from this repository into your project directory.

```bash
$ wget https://raw.githubusercontent.com/UBC-Geography/jupyter-makefile/main/Makefile
```

4. Update the PROJECT_NAME variable in the Makefile. This will be used to identify your kernel in the Jupyter launcher.

5. Upload your environment files to the project directory, if you have any.

## Usage

### To Create a Kernel

```bash
$ make create_kernel
```

Note: The default kernel is Python-based. To create an R kernel, you can either update the LANG variable in the Makefile or set the variable when creating the kernel:

```bash
$ make create_kernel LANG=R
```

### To Remove a Kernel

```bash
$ make remove_kernel
```

### Installing New Packages

#### Conda/Mamba

```bash
# Install packages from conda-forge
$ mamba install -p ~/<project_directory>/env <package_name>
# Recommended: Update the mamba/conda environment file
$ mamba env export -p ~/<project_directory>/env > environment.yml
```

#### Pip

```bash
# Use 'conda run' to execute pip within your Conda environment and install packages from PyPI
$ conda run -p ~/<project-directory>/env python -m pip install <package_name>
# Recommended: Update the pip requirements file
$ conda run -p ~/<project-directory>/env python -m pip freeze > requirements.txt
```

#### CRAN

```bash
# Use 'conda run' to execute install.packages within your Conda environment and install packages from CRAN
$ conda run -p ~/<project-directory>/env Rscript -e "install.packages("<package_name>")"
# Recommended: Update your install.R file by copying the install.packages call into it
```