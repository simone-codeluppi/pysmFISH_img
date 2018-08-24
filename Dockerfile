# Install the anaconda environment
FROM continuumio/anaconda3

# Add some metadata to the image        
LABEL maintainer="simone.codeluppi@gmail.com"
LABEL version='1.0'
LABEL description=" This image is used to set up my working anaconda environment \
        to run the pysmFISH code"

# Update and upgrade system
RUN apt-get update
RUN apt-get upgrade -y

# Install some system utilities
RUN apt-get install -y apt-utils
RUN apt-get install -y vim
RUN apt-get install -y gcc 
RUN apt-get install -y mpich
RUN apt-get install -y tmux

# add zsh
RUN apt-get install -y zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
# to star zsh just type zsh


# Update conda and anaconda
RUN  ["/bin/bash", "-c", "yes | conda update -n base conda && conda update anaconda"]


# -------------------------------
# Create the pysmFISH_env
RUN ["/bin/bash", "-c", "yes | conda create --name pysmFISH_env python=3.6 h5py numpy scikit-image pandas pylint"]
RUN ["/bin/bash", "-c", "yes | source activate pysmFISH_env"]
# Update pip
RUN ["/bin/bash", "-c","yes | pip install --upgrade pip"]
RUN ["/bin/bash", "-c", "yes | conda install -c conda-forge scipy dask distributed scikit-learn jupyterlab nodejs ipympl"]
RUN ["/bin/bash", "-c", "yes | pip install nd2reader==2.1.3 sympy ruamel.yaml mpi4py sphinx sphinx_rtd_theme twine pycodestyle mypy cython"]
RUN ["/bin/bash", "-c", "yes | pip install -U loompy"]

# Final install pysmFISH
# RUN ["/bin/bash", "-c", "git clone https://github.com/linnarsson-lab/pysmFISH.git"]
# RUN cd pysmFISH
# RUN ["/bin/bash", "-c", "pip install --no-cache-dir ."]

RUN ["/bin/bash", "-c", "yes | pip install --no-cache-dir pysmFISH"]

# Add the kernel of the pysmFISH_env to the jupyter lab
RUN ["/bin/bash", "-c", "/opt/conda/envs/pysmFISH_testing_env/bin/python -m pip install ipykernel"]
RUN ["/bin/bash", "-c", "python -m ipykernel install --user --name pysmFISH_env --display-name 'pysmFISH_env'"]

# Install extension for matplotlib in jupyter lab
RUN ["/bin/bash", "-c", "jupyter labextension install @jupyter-widgets/jupyterlab-manager"]
# -------------------------------

# Add some useful commands to ~/.bashrc
RUN chmod 777 ~/.bashrc && echo 'alias jl="jupyter lab --port=8080 --ip=0.0.0.0 --no-browser --allow-root"'>> ~/.bashrc


# List the available conda envs
# Exposing ports
EXPOSE 8080 3000 1520