#include <Eigen/Core>
#include <Eigen/SparseCore>
#include <Eigen/Eigenvalues>
#include <Spectra/SymGEigsSolver.h>
#include <Spectra/MatOp/SparseGenMatProd.h>
#include <Spectra/MatOp/SparseCholesky.h>
#include <iostream>
#include <fstream>
std::vector<Eigen::Triplet<double>> readTripletFromFile(const std::string &file_name, const int nonzero)
{
    std::vector<Eigen::Triplet<double>> coefficients(nonzero);
    std::ifstream fin;
    fin.open(file_name);
    int row, col;
    double value;
    for (int i = 0; i < nonzero; i++)
    {
        fin >> row;
        fin >> col;
        fin >> value;
        coefficients[i] = Eigen::Triplet<double>(row, col, value);
    }
    fin.close();
    return coefficients;
}

int main()
{
    const int n = 960;
    const int nonzero = 184320;
    std::vector<Eigen::Triplet<double>> coefficients_A = readTripletFromFile("data_A.txt", nonzero);
    std::vector<Eigen::Triplet<double>> coefficients_B = readTripletFromFile("data_B.txt", nonzero);
    Eigen::SparseMatrix<double> A(n, n);
    A.setFromTriplets(coefficients_A.begin(), coefficients_A.end());
    Eigen::SparseMatrix<double> B(n, n);
    B.setFromTriplets(coefficients_B.begin(), coefficients_B.end());

    Spectra::SparseSymMatProd<double> Aop(A);
    Spectra::SparseCholesky<double> Bop(B);

    const int num_solution = 5;
    const int convergence_parameter = 100;

    Spectra::SymGEigsSolver<double, Spectra::SMALLEST_ALGE,
                            Spectra::SparseSymMatProd<double>,
                            Spectra::SparseCholesky<double>,
                            Spectra::GEIGS_CHOLESKY>
        eigen_solver(&Aop, &Bop, num_solution, convergence_parameter);

    eigen_solver.init();
    int num_convergence = eigen_solver.compute();

    if (eigen_solver.info() == Spectra::SUCCESSFUL)
    {
        std::cout << "success." << std::endl;
        std::cout << eigen_solver.eigenvalues()
                  << std::endl;
    }
    else
    {
        std::cout << "failed." << std::endl;
    }
    return 0;
}