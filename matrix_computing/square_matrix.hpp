#pragma once
#include "matrix.hpp"

// implementation for 2x2 matrixes only
class SquareMatrix : public Matrix 
{
public:
    SquareMatrix() = delete;
    SquareMatrix(const Matrix& m);
    SquareMatrix(std::initializer_list<std::initializer_list<float>> matrix);

    virtual ~SquareMatrix() = default;
    virtual Matrix inverted() const override;
    virtual float determinant() const override; 
private:
    SquareMatrix(int size);
    void notCorrectSizeMatrixError() const;
    float _determinant;
    static constexpr int SIZE_OF_MATRIX = 2;
};