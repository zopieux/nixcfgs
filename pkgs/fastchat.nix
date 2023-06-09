{ python3, fetchPypi, buildPythonPackage, ffmpeg, cudaPackages, mkShell
, fetchFromGithub, lib }:
let
  py = (pkgs.python3.withPackages (ps:
    with ps;
    let
      mypytorch = pytorch.override { cudaSupport = true; };
      ffmpy = buildPythonPackage rec {
        pname = "ffmpy";
        version = "0.3.0";
        # The github repo has no release tags, the pypi distribution has no tests.
        # This package is quite trivial anyway, and the tests mainly play around with the ffmpeg cli interface.
        # https://github.com/Ch00k/ffmpy/issues/60
        src = fetchPypi {
          inherit pname version;
          sha256 = "dXWRWB7uJbSlCsn/ubWANaJ5RTPbR+BRL1P7LXtvmtw=";
        };
        propagatedBuildInputs = [ ffmpeg ];
        pythonImportsCheck = [ "ffmpy" ];
      };
      gradio = buildPythonPackage rec {
        pname = "gradio";
        version = "3.23.0";
        format = "pyproject";
        disabled = pythonOlder "3.7";

        # We use the Pypi release, as it provides prebuild webui assets,
        # and its releases are also more frequent than github tags
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-v7n1nXmScQKeYwkgfH9C7YrbKX3Li74xyDw+vzLb4ZM=";
        };

        propagatedBuildInputs = [
          aiohttp
          aiofiles
          altair
          fastapi
          ffmpy
          markdown-it-py
          mdit-py-plugins
          markupsafe
          matplotlib
          numpy
          orjson
          pandas
          pillow
          pycryptodome
          python-multipart
          pydub
          pyyaml
          requests
          semantic-version
          uvicorn
          jinja2
          huggingface-hub
          fsspec
          httpx
          pydantic
          websockets
          typing-extensions
        ] ++ markdown-it-py.optional-dependencies.linkify;
        # Jesus fuck.
        postPatch = ''
          substituteInPlace requirements.txt --replace '<=0.3.3' ' '
        '';
        nativeBuildInputs =
          [ hatchling hatch-requirements-txt hatch-fancy-pypi-readme ];
        doCheck = false;
      };
      myaccelerate = accelerate.override { torch = mypytorch; };
      mypeft = peft.override {
        torch = mypytorch;
        accelerate = myaccelerate;
      };
    in [
      mypytorch
      myaccelerate
      prompt_toolkit
      rich
      psutil
      transformers
      sentencepiece
      fastapi
      uvicorn
      gradio
      fire
      mypeft
      cudaPackages.cuda_nvrtc
    ]));
  src = fetchFromGithub {
    owner = "lm-sys";
    repo = "FastChat";
    rev = "master";
    hash = lib.fakeHash;
  };
in mkShell {
  packages = [ py ];
  buildInputs = [ cudaPackages.cuda_nvrtc ];
  LD_LIBRARY_PATH = "${cudaPackages.cuda_nvrtc}/lib";
}
