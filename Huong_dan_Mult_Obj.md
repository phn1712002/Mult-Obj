# Các thuật toán tối ưu đa mục tiêu

## Giới thiệu

Dự án cung cấp các triển khai bằng MATLAB của các thuật toán tối ưu đa mục tiêu phổ biến. Các thuật toán này được thiết kế để giải quyết các bài toán tối ưu với nhiều mục tiêu xung đột.

## Cấu trúc file

```
Mult-Obj/
├── algorithms/         # Thư mục chứa các file triển khai thuật toán
│   ├── MOABC.m            # Artificial Bee Colony
│   ├── MOACO.m            # Ant Colony Optimization
│   ├── MOAEBO.m           # ...
│   └── ... (các thuật toán khác)
├── measurements/       # Các hàm đo lường hiệu suất
│   ├── calculateGD.m      # Tính khoảng cách 
│   └── calculateHV.m      # Tính Hypervolume
├── problems/           # Các bài toán mục tiêu
│   ├── myFitness.m        # Hàm mục tiêu tùy chỉnh
│   └── ZDTProblems.m      # Các bài toán benchmark ZDT
├── utils/              # Các tiện ích hỗ trợ
│   ├── AddNewSolToArchive.m
│   ├── DetermineDomination.m
│   └── ... (nhiều tiện ích khác)
├── benchmark.m         # Script chạy kiểm thử trên ZDT
├── runMOABC.m          # Script chạy thuật toán ABC
├── runMOACO.m          # Script chạy thuật toán ACO
└── ... (các script chạy thuật toán khác)
```

## Cách sử dụng

### Chạy thuật toán với hàm mục tiêu tùy chỉnh

1. Chỉnh sửa `problems/myFitness.m` để định nghĩa các hàm mục tiêu của bạn
2. Chạy script tương ứng của thuật toán (ví dụ `runMOABC.m`)

## Kết quả đầu ra

Kết quả được lưu trong:

- `matlab.mat` - File dữ liệu MATLAB
- `Optimal.xlsx` - File Excel chứa nghiệm Pareto front
- Các đồ thị tự động hiển thị

## Các tiện ích hỗ trợ

Thư mục `utils/` chứa nhiều hàm hỗ trợ quan trọng:

- `OutResults.m`  - Xuất kết quả
- `plotChart.m`   - Vẽ đồ thị kết quả
- `{...}.m`         - Các file khác hổ trợ cho tính toán

## Tác giả

Phạm Hoàng Nam - phn1712002@gmail.com
