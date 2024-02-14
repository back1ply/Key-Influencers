// FilePath
let
    Source = "N:\Projects\Key Influencers\insurance.csv"
in
    Source

// insurance python
let
    Source = Csv.Document(File.Contents(FilePath),[Delimiter=",", Columns=7, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"age", Int64.Type}, {"sex", type text}, {"bmi", type number}, {"children", Int64.Type}, {"smoker", type text}, {"region", type text}, {"charges", type number}}),
    #"Run Python script" = Python.Execute("# dataset holds the input data for this script#(lf)import pandas as pd#(lf)from sklearn.linear_model import LinearRegression#(lf)df = dataset#(lf)#convert the data into dumy variables#(lf)df1= pd.get_dummies(df,drop_first=True)#(lf)#create a regression model#(lf)model = LinearRegression()#(lf)#create X and Y variables#(lf)X = df1.drop('charges',axis=1)#(lf)y = df1['charges']#(lf)#fit the model to the existing data#(lf)model.fit(X,y)#(lf)#let's see what the coefficients are and their Influence charges#(lf)output = pd.DataFrame(zip(X.columns, model.coef_), columns=['feature', 'Influence/Coefficient']).\#(lf)    sort_values(by='Influence/Coefficient', ascending=False)",[dataset=#"Changed Type"]),
    output = #"Run Python script"{[Name="output"]}[Value],
    #"Changed Type1" = Table.TransformColumnTypes(output,{{"feature", type text}, {"Influence/Coefficient", type number}})
in
    #"Changed Type1"