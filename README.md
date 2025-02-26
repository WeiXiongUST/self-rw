# Online-DPO-R1: Unlocking Effective Reasoning Without the PPO Overhead

<div align="center">
  <a href="https://efficient-unicorn-451.notion.site/Online-DPO-R1-Unlocking-Effective-Reasoning-Without-the-PPO-Overhead-1908b9a70e7b80c3bc83f4cf04b2f175">
    <img src="https://www.notion.so/front-static/favicon.ico" alt="Notion Icon">
  </a>
  <br>
  <a href="https://efficient-unicorn-451.notion.site/Online-DPO-R1-Unlocking-Effective-Reasoning-Without-the-PPO-Overhead-1908b9a70e7b80c3bc83f4cf04b2f175">Notion Page</a>
</div>


This is the repository for running the Iterative DPO with rule-based rewards. In every iteration, we sample responses from the model and label the rewards using the rule-based method. We then construct the preference pair based on the reward scores for DPO training. In our code, we perform iterative DPO starting with Qwen2.5-MATH-7B with prompts from Numina-Math. After the DPO training, our model achieves 26.7% on AIME24, 76.8% on MATH500, 62.5% on AME, 30.5% on Minerva-Math, and 37.9% on OlympiadBench, surpassing Llama-3.1-70B-Instruct and nearly on par with Eurus-2-7B-PRIME which adopts SFT and PPO training.

## Introduction

Inspired by the success of Deepseek-R1-Zero and several replications of PPO training which achieve superior performance on mathematical reasoning and demonstrate the “Aha moment” during RL training, we are curious about alternative algorithms in RL in this scenario. In this project, we implement rule-based RL from Qwen2.5-MATH-7B-base using iterative DPO and rejection sampling (RAFT), which are efficient and easy to implement. We train the models using the prompt set from the MATH training set and Numina-Math, and evaluate the models on AIME24, AMC23, MATH500, Minerva Math, and OlympiadBench. After several iterations, our models achieve an overall accuracy of 50.0% for DPO after SFT warm-up, 47.0% for DPO starting from the Base Model, and 44.4% for RAFT, compared to 33.9% for the Base Model. We list the result as follows:

<div align="center">

| Benchmark | Method | Turn 1 | Final Accuracy | Improvement | w2c | c2w|  
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|    |  Base | 65.4 | 65.4  |  -  |    -  | -     | - |
|    |  Prompt with Gold RM| 65.4 | 66.8  |  1.4  |    1.4  | 0.0    | 
|    |  Intrinsic Self-correction | 65.4 | 51.4 |  -14.0  |    1.4  | 15.4   | 
|  MATH  |  STaR/RAFT | 71.6 | 70.4  |  -1.2  |    5.0  | 6.2     | 
|    |  STaR/RAFT+ | 72.0 | 71.2  |  -0.8  |    3.0  | 3.8     | 
|    |  **Self-rewarding IFT** | 72.6 | 77.2  |  4.6  |   5.0 | 0.4 | 
|    |  **Self-rewarding IFT + DPO** | 72.8 | 78.6|  **5.8** |   6.0 | 0.2  | 
|    |  **Self-rewarding IFT + PPO** | 75.8| **80.2**  |  4.4  |   4.8 | 0.4   | 
|  -  |  - | -| -  |  -  |   - | -  | 
|    |  Base | 23.4 | 23.4  |  -  |    -  | -     | - |
|    |  Prompt with Gold RM| 23.4 | 25.6  |  2.2  |    2.2  | 0.0    | 
|    |  Intrinsic Self-correction | 23.4 | 18.1 |  -5.3  |    2.2  | 7.5   | 
|  OlympiadBench  |  STaR/RAFT | 36.5 | 32.5  |  -4.0  |    7.2  | 11.2     | 
|    |  STaR/RAFT+ | 35.7 | 35.5  |  -0.2  |    3.2  | 3.4     | 
|    |  **Self-rewarding IFT** | 35.4 | 39.4  |  **4.0**  |   4.7 | 0.7 | 
|    |  **Self-rewarding IFT + DPO** | 37.6 | 40.1|  2.5 |   3.5 | 1.0  | 
|    |  **Self-rewarding IFT + PPO** | 41.0| **43.4**  |  2.4  |   2.8 | 0.4   | 
|  -  |  - | -| -  |  -  |   - | -  | 



</div>

Our key findings:
* DPO and RAFT significantly improve model performance while remaining efficient and easy to implement.
* Iterative DPO does NOT benefit from the additional Negative Log-Likelihood (NLL) loss.
* DPO with SFT warm-up contributes to the training and improves performance.
* Compared to the PPO algorithm (51.8%), DPO/RAFT achieves an inferior performance, showing that PPO is still one of the most effective RL algorithms in this context.
* SFT Warm-Up before DPO could improve the model performance (51.8%) and be competent with Qwen-PPO-R1-Zero.

## Training and Evaluation

Please refer to the different parts for detailed instructions.



## Citation

The authors would like to thank the great open-source communities, including the developers of vLLM, VeRL, OpenRLHF, Qwen, and Axolotl for sharing their models, codes, and training recipes. 

If you find our paper or code useful, it would be highly appreciated if you could consider citing our work by:

```bibtex
xx
}
