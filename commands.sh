#!/bin/bash
mkdir -p /home/zy/Canvas/algo/stage4/2node8gpu/output/json
cd /home/zy/Canvas/algo/stage4/2node8gpu/output/json

canvas  search \
        ALIYUN \
        Allgather \
        --topology-file /home/zy/Canvas/algo/stage4/2node8gpu/input/topo/topo-a100-1MB.json \
        --sketch-file /home/zy/Canvas/algo/stage4/2node8gpu/input/sketch/sk-a100.json

# 不使用流水线调度
mkdir -p /home/zy/Canvas/algo/stage4/2node8gpu/output/xml/without_pipeline
cd /home/zy/Canvas/algo/stage4/2node8gpu/output/xml/without_pipeline
canvas ncclize /home/zy/Canvas/algo/stage4/2node8gpu/output/json/Allreduce_algo.json --instance 1

# 使用流水线调度
mkdir -p /home/zy/Canvas/algo/stage4/2node8gpu/output/xml/with_pipeline
cd /home/zy/Canvas/algo/stage4/2node8gpu/output/xml/with_pipeline
canvas ncclize_pipeline /home/zy/Canvas/algo/stage4/2node8gpu/output/json/Allreduce_algo.json --instance 1

# 同步xml文件到两台机器
cp /home/zy/Canvas/algo/stage4/2node8gpu/output/xml/without_pipeline/algo.xml /home/zy/ys-canvas/exp/xml/2node8gpu/
scp /home/zy/Canvas/algo/stage4/2node8gpu/output/xml/without_pipeline/algo.xml zy@10.0.0.103:/home/zy/ys-canvas/exp/xml/2node8gpu/

# 运行测试
# TACCL
# mpirun -np 16 \
#         --allow-run-as-root \
#         -hostfile /home/zy/ys-canvas/exp/hostfile_16 \
#         -mca btl_tcp_if_include 10.0.0.0/24 \
#         -x NCCL_SOCKET_IFNAME=enp193s0 \
#         -mca btl_openib_allow_ib true \
#         -x LD_LIBRARY_PATH=/home/zy/ys-canvas/msccl/build/lib/:$LD_LIBRARY_PATH \
#         -x NCCL_DEBUG=INFO \
#         -x NCCL_IGNORE_DISABLED_P2P=1 \
#         -x CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
#         -x NCCL_P2P_LEVEL=NVL \
#         -x NCCL_ALGO=MSCCL,RING,TREE \
#         -x NCCL_BUFF_SIZE=2197152 \
#         -x MSCCL_XML_FILES=algo.xml \
#         -x NCCL_DEBUG_SUBSYS=INIT,ENV \
#         -x NCCL_IB_DISABLE=1 \
#         /home/zy/ys-canvas/nccl-tests/build/all_reduce_perf -b 1MB -e 1GB -f 4 -g 1 -n 1 -w 1


# Canvas
mpirun -np 16 \
        --allow-run-as-root \
        -hostfile /home/zy/ys-canvas/exp/hostfile_16 \
        -mca btl_openib_warn_no_device_params_found 0 \
        -mca pml ob1 \
        -mca btl_tcp_if_include eno1 \
        -mca btl ^ucx \
        --prefix /home/zy/mpi/openmpi \
        -x NCCL_SOCKET_IFNAME=eno1 \
        -x LD_LIBRARY_PATH=/home/zy/ys-canvas/msccl/build/lib/:$LD_LIBRARY_PATH \
        -x NCCL_DEBUG=INFO \
        -x NCCL_IGNORE_DISABLED_P2P=1 \
        -x NCCL_ALGO=MSCCL,RING,TREE \
        -x MSCCL_XML_FILES=algo.xml \
        -x NCCL_BUFF_SIZE=2197152 \
        -x NCCL_DEBUG_SUBSYS=INIT,ENV \
        -x NCCL_IB_DISABLE=1 \
        /home/zy/ys-canvas/nccl-tests/build/all_reduce_perf -b 1MB -e 16MB -f 4 -g 1 -n 1 -w 1

# NCCL
# mpirun -np 16 \
#         --allow-run-as-root \
#         -hostfile /home/zy/ys-canvas/exp/hostfile_16 \
#         -mca btl_openib_warn_no_device_params_found 0 \
#         -mca pml ob1 \
#         -mca btl_tcp_if_include eno1 \
#         -mca btl ^ucx \
#         --prefix /home/zy/mpi/openmpi \
#         -x NCCL_SOCKET_IFNAME=enp193s0 \
#         -x LD_LIBRARY_PATH=/home/zy/ys-canvas/msccl/build/lib/:$LD_LIBRARY_PATH \
#         -x NCCL_DEBUG=INFO \
#         -x NCCL_IGNORE_DISABLED_P2P=1 \
#         -x NCCL_ALGO=RING,TREE \
#         -x NCCL_BUFF_SIZE=2197152 \
#         -x NCCL_DEBUG_SUBSYS=INIT,ENV \
#         -x NCCL_IB_DISABLE=1 \
#         /home/zy/ys-canvas/nccl-tests/build/all_reduce_perf -b 1MB -e 1GB -f 4 -g 1 -n 1 -w 1
