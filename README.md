# Canvas: Scalable and Optimal Collective Communication Scheduling for Large-Scale GPU Clusters

Canvas是一个拓扑感知的集体通信库，专为高性能计算和分布式机器学习环境设计。它能够基于特定的网络拓扑结构优化通信模式，从而提高分布式系统的通信效率。

## 项目特点

- 基于拓扑结构的通信优化
- 支持多种集合通信操作（如AllReduce, AllGather等）
- 与NCCL兼容的接口
- 灵活的通信调度器
- 高效的路由算法

## 安装

### 前提条件

- Python 3.6+
- 依赖包：
  - z3-solver
  - argcomplete
  - lxml
  - gurobipy
  - numpy
  - ply

### 安装步骤

```bash
# 克隆仓库
git clone https://github.com/Sibuge/Canvas.git
cd Canvas

# 安装依赖
pip install -e .
```

## 使用方法

提供了类似TACCL的命令行工具，可以通过以下命令使用：

```bash
# 生成通信方案
taccl solve [options]

# 合并通信方案
taccl combine [options]

# 转换为NCCL兼容格式
taccl ncclize [options]

# 搜索通信方案
taccl search [options]

# 流水线优化
taccl ncclize-pipeline [options]
```

### 示例

包含了一些示例，可以在`taccl/examples`目录下找到：
- 拓扑示例（`taccl/examples/topo/`）
- Sketch示例（`taccl/examples/sketch/`）

详细的使用方法和参数说明请参考命令行帮助：

```bash
taccl --help
taccl <command> --help
```