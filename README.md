# Efficient Scheduling of Discrete Industrial Processes through Continuous Modeling

## Cite: R. Lyu, X. Su, E. Du, H. Guo, Q. Chen and C. Kang. “Efficient Scheduling of Discrete Industrial Processes through Continuous Modeling”, IEEE Transactions on Smart Grid, in press.

## video introduction: https://www.bilibili.com/video/BV1cdurzbEgi

## Project Overview
This project provides research data and code for accelerating the application of RTN models in discrete industrial production processes. By using continuous modeling methods, we can improve scheduling efficiency and reduce computation time.

<img width="506" alt="image" src="https://github.com/user-attachments/assets/e8300ec6-8231-4175-abb5-bc39ace05b92" />

<img width="509" alt="image" src="https://github.com/user-attachments/assets/f001b792-9ec3-4257-b3cb-5232ecdcc46d" />


## Code Structure
- `cRTN_model/`: Contains the main scripts and functions for the cRTN model.
  - `add_crtn_cons.m`: Defines the constraints for the cRTN model.
  - `add_crtn_param_and_var.m`: Initializes parameters and variables for the cRTN model.
  - `main_flxb_crtn.m`: Main script for running the flexible cRTN model.
  - `main_small_case_crtn.m`: Runs the cRTN model for small-scale cases.
  - `test_crtn_gap.m`: Tests the impact of different gap values on the model results.
  - `test_crtn_heat.m`: Tests the impact of different NOF_HEAT values on the model results.
- `RTN_model/`: Contains the main scripts and functions for the RTN model.
  - `add_basic_rtn_cons.m`: Defines the basic constraints for the RTN model.
  - `add_flxb_rtn_cons.m`: Defines the flexible constraints for the RTN model.
  - `add_rtn_param_and_var.m`: Initializes parameters and variables for the RTN model.
  - `main_basic_rtn.m`: Main script for running the basic RTN model.
  - `main_flxb_rtn.m`: Main script for running the flexible RTN model.
  - `main_flxb_rtn_small_case.m`: Runs the flexible RTN model for small-scale cases.
  - `test_rtn_gap.m`: Tests the impact of different gap values on the RTN model results.
  - `test_rtn_heat.m`: Tests the impact of different NOF_HEAT values on the RTN model results.
- `visualize/`: Contains scripts for result visualization.
  - `plot_typical_load_profile_decp_crtn.m`: Plots typical load profiles.

## Usage
1. Ensure MATLAB is installed and configured correctly.
2. Clone the project to your local machine.
3. In MATLAB, set the current folder to the project's root directory.
4. Run the `cRTN_model/main_flxb_crtn.m` script to start the scheduling computation.

# Frequently Asked Questions (FAQ)

## Q1: What is the relationship between RTN and cRTN models?
A: cRTN inherits RTN's graph-based modeling philosophy but introduces a fundamental innovation in variable definition. While traditional RTN uses discrete variables to represent both resource quantities and task operations, cRTN reformulates these using continuous variables while preserving the discrete nature of IPPs through carefully designed binary variables for task states.

## Q2: Why are the improvements in energy costs relatively small in some cases?
A: There are two main reasons:
1. When given sufficient computation time, both RTN and cRTN can find optimal solutions, resulting in similar energy costs. This validates that cRTN achieves better computational efficiency without compromising modeling accuracy.
2. The magnitude of energy cost improvements through eliminating rounding errors depends on the time step length relative to process duration. With smaller time steps, the impact is less prominent.

## Q3: How does the solver's optimality gap setting affect performance?
A: Our analysis shows:
1. RTN's solution time increases rapidly with stricter gap requirements (>1 hour when gap < 1e-2)
2. cRTN maintains stable performance even with very strict gap requirements
3. Given a 30-minute time limit, cRTN consistently achieves gaps < 1e-4, while RTN only reaches gaps around 1e-2

## Q4: Is there potential for clustering binary variables to improve computational efficiency?
A: While clustering methods (like those used in Unit Commitment problems) could potentially help accelerate aggregated industrial demand response strategies involving multiple factories, they may not be directly applicable for individual factory scheduling. Our cRTN approach focuses on improving computational efficiency while maintaining accurate modeling of individual IPP constraints.

## Q5: How does cRTN ensure the feasibility of solutions?
A: cRTN is a reformulation rather than a relaxation of the RTN model. While we model resources as continuous variables, we maintain the discrete nature of IPPs by introducing binary variables to represent task execution states. Our carefully designed constraints mathematically ensure that the model maintains strict feasibility without compromising the original problem's discrete characteristics.

# 离散型工业生产过程的计算高效建模方法

## 项目简介
本项目提供了加速RTN模型在离散工业生产过程中的应用的研究数据和代码。通过连续建模的方法，我们能够在保证精度的前提下减小模型复杂度，从而提高调度效率，减少计算时间。

## 代码结构
- `cRTN_model/`: 包含cRTN模型的主要脚本和函数。
  - `add_crtn_cons.m`: 定义cRTN模型的约束条件。
  - `add_crtn_param_and_var.m`: 初始化cRTN模型的参数和变量。
  - `main_flxb_crtn.m`: 主脚本，用于运行灵活的cRTN模型。
  - `main_small_case_crtn.m`: 用于运行小规模案例的cRTN模型。
  - `test_crtn_gap.m`: 测试不同gap值对模型结果的影响。
  - `test_crtn_heat.m`: 测试不同NOF_HEAT值对模型结果的影响。
- `RTN_model/`: 包含RTN模型的主要脚本和函数。
  - `add_basic_rtn_cons.m`: 定义RTN模型的基本约束条件。
  - `add_flxb_rtn_cons.m`: 定义RTN模型的灵活约束条件。
  - `add_rtn_param_and_var.m`: 初始化RTN模型的参数和变量。
  - `main_basic_rtn.m`: 运行基本RTN模型的主脚本。
  - `main_flxb_rtn.m`: 运行灵活RTN模型的主脚本。
  - `main_flxb_rtn_small_case.m`: 用于运行小规模案例的灵活RTN模型。
  - `test_rtn_gap.m`: 测试不同gap值对RTN模型结果的影响。
  - `test_rtn_heat.m`: 测试不同NOF_HEAT值对RTN模型结果的影响。


## 使用方法
1. 确保MATLAB已安装并配置正确。
2. 将项目克隆到本地计算机。
3. 在MATLAB中，将当前文件夹设置为项目的根目录。
4. 运行`cRTN_model/main_flxb_crtn.m`脚本以开始调度计算。

## 运行说明
- **参数设置**：在`main_flxb_crtn.m`中，用户可以根据需要调整`NOF_HEAT`、`day_index`和`gap`等参数。
- **结果保存**：运行结束后，结果将保存在`results/`文件夹中，文件名中包含`day_index`、`NOF_HEAT`和`gap`信息。
- **可视化**：使用`visualize/plot_typical_load_profile_decp_crtn.m`脚本可以生成负荷曲线图，帮助分析结果。

# 常见问题解答 (FAQ)

## Q1: RTN模型和cRTN模型之间的关系是什么？
A: cRTN继承了RTN的图形化建模理念，但在变量定义上进行了根本性的创新。传统的RTN使用离散变量来表示资源数量和任务操作，而cRTN通过精心设计的二进制变量来表示任务状态，将这些变量重新定义为连续变量，同时保留了IPP的离散特性。

## Q2: 为什么在某些情况下，能源成本的改善相对较小？
A: 主要有两个原因：
1. 在给予足够计算时间的情况下，RTN和cRTN都能找到最优解，导致相似的能源成本。这验证了cRTN在不影响建模精度的前提下，实现了更好的计算效率。
2. 通过消除舍入误差来改善能源成本的幅度取决于时间步长相对于过程持续时间的长短。时间步长越小，影响越不明显。

## Q3: 求解器的最优性间隙设置如何影响性能？
A: 我们的分析显示：
1. RTN的求解时间随着更严格的间隙要求迅速增加（当间隙<1e-2时，超过1小时）
2. 即使在非常严格的间隙要求下，cRTN也能保持稳定的性能
3. 在30分钟的时间限制下，cRTN始终能达到间隙<1e-4，而RTN只能达到约1e-2的间隙

## Q4: 是否有可能通过聚类二进制变量来提高计算效率？
A: 虽然聚类方法（如在单元承诺问题中使用的那些）可能有助于加速涉及多个工厂的工业需求响应策略，但它们可能不直接适用于单个工厂的调度。我们的cRTN方法专注于在保持单个IPP约束的准确建模的同时，提高计算效率。

## Q5: cRTN如何确保解的可行性？
A: cRTN是RTN模型的重新表述，而不是放松。虽然我们将资源建模为连续变量，但通过引入二进制变量来表示任务执行状态，保持了IPP的离散特性。我们精心设计的约束条件在数学上确保了模型在不影响原问题离散特性的情况下，严格保持可行性。
