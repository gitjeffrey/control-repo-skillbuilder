module=$1

mkdir ./modules/${module}
mkdir ./modules/${module}/manifests
mkdir ./modules/${module}/files
mkdir ./modules/${module}/lib
mkdir ./modules/${module}/facts.d
mkdir ./modules/${module}/templates
mkdir ./modules/${module}/examples
mkdir ./modules/${module}/spec
mkdir ./modules/${module}/functions
mkdir ./modules/${module}/types

chmod 755 ./modules/${module}/manifests
chmod 755 ./modules/${module}/files
chmod 755 ./modules/${module}/lib
chmod 755 ./modules/${module}/facts.d
chmod 755 ./modules/${module}/templates
chmod 755 ./modules/${module}/examples
chmod 755 ./modules/${module}/spec
chmod 755 ./modules/${module}/functions
chmod 755 ./modules/${module}/types

