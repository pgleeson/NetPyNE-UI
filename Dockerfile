FROM jupyter/base-notebook:eb70bcf1a292

# Create a Python 2.x environment using conda including at least the ipython kernel
# and the kernda utility. Add any additional packages you want available for use
# in a Python 2 notebook to the first line here (e.g., pandas, matplotlib, etc.)
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 ipython ipykernel kernda && \
    conda clean -tipsy

USER root

ARG netpyneuiBranch=development
ENV netpyneuiBranch=${netpyneuiBranch}
RUN echo "$netpyneuiBranch";

RUN apt-get -qq update

ARG NRN_VERSION="7.4"
ARG NRN_ARCH="x86_64"

RUN apt-get -qq install -y \
        locales \
        wget \
        gcc \
        g++ \
        build-essential \
        libncurses-dev \
        python2.7 \
        libpython-dev \
        cython \
        git-core \
        unzip \
        libpng-dev
# Create a global kernelspec in the image and modify it so that it properly activates
# the python2 conda environment.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install && \
$CONDA_DIR/envs/python2/bin/kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json

USER $NB_USER

RUN python --version
RUN conda create --name snakes python=2
RUN python --version
RUN wget http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/nrn-7.4.tar.gz
RUN tar xzf nrn-7.4.tar.gz
WORKDIR nrn-7.4
RUN /bin/bash -c "source activate snakes && ./configure --prefix `pwd` --without-iv --with-nrnpython"
RUN /bin/bash -c "source activate snakes && make --silent"
RUN /bin/bash -c "source activate snakes && make --silent install"
RUN python --version
WORKDIR src/nrnpython
ENV PATH="/home/jovyan/work/nrn-7.4/x86_64/bin:${PATH}"
RUN /bin/bash -c "source activate snakes && python setup.py install"
RUN wget https://github.com/MetaCell/NetPyNE-UI/archive/$netpyneuiBranch.zip
RUN unzip $netpyneuiBranch.zip
WORKDIR NetPyNE-UI-$netpyneuiBranch/utilities
RUN /bin/bash -c "source activate snakes && python --version"
RUN /bin/bash -c "source activate snakes && exec python install.py"
RUN cd ../netpyne_ui/tests && /bin/bash -c "source activate snakes && python -m unittest netpyne_model_interpreter_test"
RUN mkdir /home/jovyan/netpyne_workspace
WORKDIR /home/jovyan/netpyne_workspace
CMD /bin/bash -c "source activate snakes && exec jupyter notebook --ip=0.0.0.0 --allow_root=true --debug --NotebookApp.default_url=/geppetto --NotebookApp.token=''"
RUN jupyter kernelspec list
RUN python --version
