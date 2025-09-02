#! /usr/bin/env python3
'''
Create the matrices for the Matrix Multiply project in 18-341
'''
from argparse import ArgumentParser
from random import randint

def main():
    # Parse the three output file names
    parser = ArgumentParser(description="Generate random matrices for P2")
    parser.add_argument("mat_a", default="matA_gen.coe",
                        help="Matrix A .coe output")
    parser.add_argument("mat_b", default="matB_gen.coe",
                        help="Matrix B .coe output")
    parser.add_argument("mat_c", default="matC_gen.coe",
                        help="Matrix C .coe output")
    args = parser.parse_args()

    matrix_dim = 128

    flat_mat_a = [randint(0, 0xff) for c in range(matrix_dim * matrix_dim)]
    mat_b = [randint(0, 0xff) for r in range(matrix_dim)]
    mat_c = [randint(0, 0xffff) for r in range(matrix_dim)]

    c_sum = 0
    ab_sum = 0

    for i in range(matrix_dim):
        for j in range(matrix_dim):
            ab_sum += flat_mat_a[i * matrix_dim + j] * mat_b[j]

        c_sum += mat_c[i]

    mma_product = ab_sum + c_sum

    with open(args.mat_a, "w") as fout:
        fout.write("memory_initialization_radix=16;\n")
        fout.write("memory_initialization_vector=\n")
        for i, v in enumerate(flat_mat_a):
            separator = "," if i < (len(flat_mat_a) - 1) else ";"
            fout.write(f"{v:02X}{separator}\n")

    with open(args.mat_b, "w") as fout:
        fout.write("memory_initialization_radix=16;\n")
        fout.write("memory_initialization_vector=\n")
        for i, v in enumerate(mat_b):
            separator = "," if i < (len(mat_b) - 1) else ";"
            fout.write(f"{v:02X}{separator}\n")

    with open(args.mat_c, "w") as fout:
        fout.write("memory_initialization_radix=16;\n")
        fout.write("memory_initialization_vector=\n")
        for i, v in enumerate(mat_c):
            separator = "," if i < (len(mat_c) - 1) else ";"
            fout.write(f"{v:04X}{separator}\n")

    print("Matrix files created: {} {} {}".format(args.mat_a,
                                                  args.mat_b,
                                                  args.mat_c))

    print("Ab sum: 0x{:08x}".format(ab_sum))
    print("C sum: 0x{:08x}".format(c_sum))
    print("MMA product: 0x{:08x}".format(mma_product))

if __name__ == "__main__":
    main()
