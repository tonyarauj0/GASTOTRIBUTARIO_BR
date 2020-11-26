# GASTOTRIBUTARIO_BR
	*Buscar evidencias sobre a existencia de ciclos politicos no Gasto Tributário (GT) brasileiro entre os anos de 1997 até 2018.*

	*A variável de interesse encontra-se regionalizada.
	
	*Foram estimadas dez regressões para cada um dos principais impostos administrados pela Secretaria da Receita Federal, adotando-se a mesma forma funcional para cada um deles.
	
	*Estimou-se um modelo pooled com erros robustos. Os testes de Chow e Breusch-Pagan embasaram essa escolha.
	
	*Uma alternativa seria estimar um modelo dinâmico via Método dos Momentos Generalizados (GMM) onde a variável dependente defasada entraria no modelo como explicativa. Mas, devido ao pequeno número de grupos (cinco regiões) existiriam problemas com os testes estatísticos implementados.
	
	*Com o intuito de se observar a presença de ciclos políticos, foram incluídas três dummies. Uma para um ano após a eleição (d_1), outra para dois anos após a eleição(d_2),  e uma para três anos após a eleição (d_3).
	
	*O ciclo se configura por um aumento dos gastos no ano do pleito ou no ano imediatamente anterior e diminuição dos mesmos nos demais períodos.
	
	*Houve uma enorme expansão da renuncia fiscal nos governos ligados ao Partido dos Trabalhadores (PT). Portanto, incluíram-se também variáveis binárias para o governo LULA e DILMA.
	
	*Por fim, adicionou-se outra dummy para o ano de 2009 devido à crise econômica mundial.
	


