pip3 wheel --wheel-dir=../os-setup-common-files/python-packages -r ./requirements.txt

pip3 install --no-index --find-links=../os-setup-common-files/python-packages -r ./requirements.txt
