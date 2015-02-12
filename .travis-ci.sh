OPAM_DEPENDS="postgresql oUnit re"
case "$OCAML_VERSION,$OPAM_VERSION" in
4.00.1,1.0.0) ppa=avsm/ocaml40+opam10 ;;
4.00.1,1.1.0) ppa=avsm/ocaml40+opam11 ;;
4.00.1,1.2.0) ppa=avsm/ocaml40+opam12 ;;
4.01.0,1.0.0) ppa=avsm/ocaml41+opam10 ;;
4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
4.01.0,1.2.0) ppa=avsm/ocaml41+opam12 ;;
4.02.0,1.0.0) ppa=avsm/ocaml42+opam10 ;;
4.02.0,1.1.0) ppa=avsm/ocaml42+opam11 ;;
4.02.0,1.2.0) ppa=avsm/ocaml42+opam12 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac
echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
sudo -u postgres createdb ocaml_psql_test
export OPAMYES=1
export OPAMVERBOSE=1
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version
opam init
opam install ${OPAM_DEPENDS}
eval `opam config env`
ocaml setup.ml -configure --enable-tests
ocaml setup.ml -build
export OCAML_PSQL_CONNINFO="host=127.0.0.1 port=5432 dbname=ocaml_psql_test user=postgres password="
ocaml setup.ml -test
