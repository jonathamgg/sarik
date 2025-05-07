# Importando bibliotecas para cálculo estatístico
from scipy import stats
import pandas as pd

# Lendo dados do arquivo CSV
data = pd.read_csv("metricas_para_test_F_e_t.csv")

# Separando dados em dois grupos
group1 = data[data["Group"] == "Group 1"]["Block rate"]
group2 = data[data["Group"] == "Group 2"]["Block rate"]

# Testando normalidade dos dados com o teste de Shapiro-Wilk
shapiro_test_g1 = stats.shapiro(group1)
shapiro_test_g2 = stats.shapiro(group2)

# Verificando se os dados seguem uma distribuição normal
if shapiro_test_g1[1] >= 0.05 and shapiro_test_g2[1] >= 0.05:
    # Realizando teste t para comparar médias entre dois grupos
    t_test = stats.ttest_ind(group1, group2)
    print("Resultado do teste t:")
    print("Valor-p: ", t_test.pvalue)
    print("t-value: ", t_test.statistic)
else:
    # Testando homogeneidade de variância com teste de Levene
    levene_test = stats.levene(group1, group2)
    if levene_test.p >= 0.05:
        # Realizando teste t para comparar médias entre dois grupos
        t_test = stats.ttest_ind(group1, group2)
        print("Resultado do teste t:")
        print("Valor-p: ", t_test.pvalue)
        print("t-value: ", t_test.statistic)
    else:
        # Realizando teste t de Welch para comparar médias entre dois grupos
        # com variâncias diferentes
        t_test = stats.ttest_ind(group1, group2, equal_var=False)
        print("Resultado do teste t de Welch:")
        print("Valor-p: ", t_test.pvalue)
        print("t-value: ", t_test.statistic)

# Realizando teste F para comparar variações entre dois grupos
levene_test = stats.levene(group1, group2)
if levene_test.pvalue >= 0.05:
    f_test = stats.f_oneway(group1, group2)
    print("\nResultado do teste F:")
    print("Valor-p: ", f_test.pvalue)
    print("F-value: ", f_test.statistic)
else:
    print("\nAtenção: os dados não possuem homogeneidade de variância.")
    print(" Utilize uma correção para o teste F, como o teste de Brown-Forsythe.")
