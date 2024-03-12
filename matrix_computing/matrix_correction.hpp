#pragma once
#include <random>
#include <chrono>
#include "matrix.hpp"

class MatrixCorrection : public Matrix
{
public:
    MatrixCorrection(std::initializer_list<std::initializer_list<float>> matrix);
    MatrixCorrection(const Matrix& m);
    virtual Matrix operator*(float) const override;
    virtual Matrix operator*(const Matrix&) const override;
    static Matrix generateRandomMatrix(int lines, int columns);
    static float getRandomFloat();
    // implementation for 2x2 matrixes only
    virtual float determinant() const override; 
    virtual Matrix inverted() const override;
private:
    MatrixCorrection(int lines, int colums);
    static constexpr int MAX_FLOAT = 100;
    static constexpr int MIN_FLOAT = -100;
    static constexpr int SIZE_OF_MATRIX = 2;
};

