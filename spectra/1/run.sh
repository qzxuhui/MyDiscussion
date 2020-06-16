eigen_path=/opt/Eigen/eigen-3.3.7
spectra_path=/opt/spectra/spectra-0.8.1/include/

rm a.out

g++ -I ${eigen_path} -I ${spectra_path} -O3 main.cpp 

time ./a.out