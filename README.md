# leader-identification
### a learning approach to (page)rank members of social groups to detect their leaders

Leader identification is a crucial task in social analysis, crowd management and emergency planning. In this paper, we investigate a computational model for the individuation of leaders in crowded scenes. We deal with the lack of a formal definition of leadership by learning, in a supervised fashion, a metric space based exclusively on people spatiotemporal information. Based on Tarde’s work on crowd psychology, individuals are modeled as nodes of a directed graph and leaders inherits their relevance thanks to other members references. We note this is analogous to the way websites are ranked by the PageRank algorithm. A compact diagram depicting the input and the training process is shown in the figure below.<br /><br />


<span>&emsp;&emsp;&emsp;</span>
<img src="https://raw.githubusercontent.com/francescosolera/leader-identification/master/figures/method.png" height="300px" />
<span>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;</span>
<a href="https://youtu.be/YKzTiv1G3I4"><img src="https://raw.githubusercontent.com/francescosolera/leader-identification/master/figures/ok36Z4.gif" height="295px" /></a>

### how to run the code
The code can be run as it from the `main.m` file. Features will be computed and the training will start.
The main code does not visualize results. In order to do that, you will need to download additional video/images data - please contact me if you need them.

### citation and contacts
If you find this code useful and use it in your research, please don't forget to cite it:

```
Solera, F.; Calderara, S.; Cucchiara, R., "Learning to Identify Leaders in Crowd"
Proc. IEEE Int'l Conf. Computer Vision and Pattern Recognition Workshops (CVPRW), Jun 2015
```

- Francesco Solera    francesco.solera@unimore.it
- Simone Calderara    simone.calderara@unimore.it
- Rita Cucchiara        rita.cucchiara@unimore.it
