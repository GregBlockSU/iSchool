
const CARD_DATA = [
  {
    title: "Python Data Types",
    desc1: [
      "Consider the following code:",
      `<pre><code>
m = True
n = 3.14
q = '-7.2345907654'
print(type(m))
print(type(n))
print(type(q))
</code></pre>`,
      "What will be the type of variables m, n, and q, respectively?`<pre><ul>",
      "<li>Integer, float an float</li>",
      "<li>Boolean, float and string</li>",
      "<li>Boolean, float and float</li>",
      "<li>Syntax error</li></ul></pre>"
    ],
    desc2: "What is Boolean, float and string."
  },,
    {
      title: "String Syntax",
      desc1: ["Given the following assignments:",
      `<pre><code>
String1 = 'Monty Python'
String2 = "Monty Python"
String3 = 'Monty ' + 'Python'
</code></pre>`,
"which of these has the correct syntax for defining a string?`<pre><ul>",
      "<li>String 1</li>",
      "<li>String 2</li>",
      "<li>String 3</li>",
      "<li>All of these</li></ul></pre>"
    ],
      desc2: "What is All of these."
    },
    {
      title: "Lists for Beginners",
      desc1: ["The correct syntax for creating an empty list named Student is`<pre><ul>",
      "<li>Students[] = 0</li>",
      "<li>Students[] = empty</li>",
      "<li>Students = []</li>",
      "<li>Students = ['']</li></ul></pre>"
    ],
      desc2: "What is Students = []."
    },
    {
      title: "Indexing Lists",
      desc1: ["Consider the following code:",
      `<pre><code>
Evennumbers = [2, 4, 6, 8, 10, 12, 14, 16, 18]
Temp = Evennumbers[1]+Evennumbers[3]
print(Evennumbers[1], Evennumbers[3], Evennumbers[7], Temp)      
</code></pre>`,
"What would be the result of the above print statement?`<pre><ul>",
      "<li>2, 6, 14, and 8</li>",
      "<li>TypeError</li>",
      "<li>4, 6, 14, and 10</li>",
      "<li>4, 8, 16, and 12</li></ul></pre>"
    ],
      desc2: "What is 4, 8, 16, and 12."
    },
    {
      title: "List Slicing",
      desc1: ["Consider the following list:",
      `<pre><code>
Suitcase = ["sunglasses", "hat", "passport", "laptop", "suit", "shoes"]
print(Suitcase[1:], Suitcase[:4])    
</code></pre>`,
"What would be the result of the print statement above?`<pre><ul>",
      "<li>[\"hat\", \"passport\", \"laptop\", \"suit\", \"shoes\"] and [\"sunglasses\", \"hat\", \"passport\", \"laptop\"]</li>",
      "<li>[\"sunglasses\"] and [\"laptop\"]</li>",
      "<li>[\"hat\"] and [\"suit\"]</li>",
      "<li>[\"sunglasses\", \"hat\", \"passport\", \"laptop\", \"suit\", \"shoes\"] and [\"sunglasses\"]</li></ul></pre>"
    ],
      desc2: "What is [\"hat\", \"passport\", \"laptop\", \"suit\", \"shoes\"] and [\"sunglasses\", \"hat\", \"passport\", \"laptop\"]."
    },
    {
      title: "Logical Operators",
      desc1: ["Which of the following expressions will make the condition inside the IF statement \"TRUE\" with the following value for x, and would result in printing the message “Welcome to the world of logical operators”?",
      `<pre><code>
x = 5
if(choose the expression from the options given below):
   print("Welcome to the world of logical operators")
else:
   print("Try Again")</code></pre>`,
"What would be the result of the print statement above?`<pre><ul>",
      "<li>x <= 0 and x < 0</li>",
      "<li>x <= 0 or x > 5</li>",
      "<li>x >= 0 or x < 0</li>",
      "<li>x == 5 and x < 5</li></ul></pre>"
    ],
      desc2: "What is  x >= 0 or x < 0."
    },
    {
      title: "Looping Through Lists",
       desc1: ["Consider the following code:",
      `<pre><code>
xlist = [1, 2, 3, 4]
for x in xlist:
     print(x + 1)      
</code></pre>`,
"What will the output be (where the numbers will be on separate lines)?`<pre><ul>",
      "<li>1 2 3 4 5</li>",
      "<li>2 3 4 5</li>",
      "<li>2 3 4 5 6</li>",
      "<li>TypeError</li></ul></pre>"
    ],
      desc2: "What is 2 3 4 5."
    },
    {
      title: "Aggregation",
       desc1: ["Consider the following program:",
      `<pre><code>
nlist = [8, 92, 79, 55, 23, 17, 4, 45, 63, 9, 100]
threshold = input('Type Threshold: ')
if (max(nlist) > int(threshold)):
    print('Great')
else:
    print('Not great')     
</code></pre>`,
"If the user types in 55, what will the result be?`<pre><ul>",
      "<li>Great</li>",
      "<li>Not great</li>",
      "<li>TypeError</li>",
      "<li>55</li></ul></pre>"
    ],
      desc2: "What is Great."
    },
    {
      title: "Data Analysis",
       desc1: ["In the blog post “Data Science: A Kaggle Walkthrough—Understanding the Data,” Brett Romero creates Chart 2—Reported Ages of Users. In this chart, we see that there are a number of people whose ages are between 100 and 1,000. This is an example of:`<pre><ul>",
      "<li>Using data inspection on a small number of examples</li>",
      "<li>Showing the number of each type of data in categorical data</li>",
      "<li>Using outliers to identify errors in data</li>",
      "<li>Summarizing a numeric field with statistics</li></ul></pre>"
    ],
      desc2: "What is Using outliers to identify errors in data."
    },
    {
      title: "String Slicing",
      desc1: ["Given the code below:",
      `<pre><code>
fruitlist = ['apple', 'pear', 'banana']
fruitlist_new = []
for x in fruitlist:
     fruitlist_new.append(x[0:3])     
</code></pre>`,
"What would be in the fruitlist_new?`<pre><ul>",
      "<li>['app', 'pea', 'ban']</li>",
      "<li>['appl', 'pear', 'bana']</li>",
      "<li>['ap', 'pe', 'ba']</li>",
      "<li>None of these</li></ul></pre>"
    ],
      desc2: "What is ['app', 'pea', 'ban']."
    },
    {
      title: "",
      desc1: "Computing, innovation, and electronics.",
      desc2: "Includes software, hardware, and AI."
    },
    {
      title: "",
      desc1: "Books, authors, and literary genres.",
      desc2: "Covers classics and modern works."
    },
    {
      title: "",
      desc1: "Government, laws, and public policy.",
      desc2: "Includes elections and political systems."
    },
    {
      title: "",
      desc1: "Ancient myths and cultural legends.",
      desc2: "Includes gods, heroes, and folklore."
    },
    {
      title: "",
      desc1: "Ecosystems, plants, and natural wonders.",
      desc2: "Includes weather and climate patterns."
    },
    {
      title: "",
      desc1: "Athletes, competitions, and rules.",
      desc2: "Includes major leagues and events."
    }
  ];
