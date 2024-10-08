{ fetchPypi, 
  python311Packages,
  fetchFromGitHub,
}:
{
  ascii = python311Packages.buildPythonPackage rec {
    pname = "ascii";
    version = "3.6";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-tf/EyyCsF4nKyAqRMZNF8mo+jzxtb+/zoiDBtsUFYUE=";
    };
  };

  pyease-grpc = python311Packages.buildPythonPackage rec {
    pname = "pyease-grpc";
    version = "v1.7.0";
    src = fetchFromGitHub {
      owner = "dipu-bd";
      repo = "pyease-grpc";
      rev = "v1.7.0";
      hash = "sha256-IE6Dryqz4wcoTbHv0HMhVYH99iq2KPYCjWhC+usc2aQ=";
    };
    propagatedBuildInputs = [
      python311Packages.protobuf
      python311Packages.requests
      python311Packages.grpcio
    ];
  };

  pycryptodome = python311Packages.buildPythonPackage rec {
    pname = "pycryptodome";
    version = "3.21.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-93h+DUab2udjuHYXTPLmwPe+eYCK8msdqW8aZLz0cpc=";
    };
  };
  
  undetected-chromedriver = python311Packages.buildPythonPackage rec {
    pname = "undetected-chromedriver";
    version = "3.5.5";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-n5ReFDUAUker4X3jFrz9qFsoSkF3/V8lFnx4ztM7Zew=";
    };
  };
}
