
const CARD_DATA = [
  {
    title: "Dictionaries",
    desc1: ["Which of the following is NOT a valid dictionary definition?`<pre><ul>",
      "<li>d = (3,'three',5,'five')</li>",
      "<li>d = {} </li>",
      "<li>d = {3:'three',5:'five'}</li>",
      "<li>d = {'3':'three','5':'five'}</li>"
    ],
    desc2: "What is:<br/><pre><code>  d = (3,'three',5,'five')</code></pre>"
  },
  {
    title: "Dictionary Aggregation",
    desc1: ["Suppose we have defined the following dictionary:<br/>",
      "<pre><code>people = {'hugh':49,'kate':35,'lucy':24,'bob':36}</pre></code>",
      "In the following list, three of the code snippets will correctly sum the values in this dictionary. Please select the one snippet that is NOT correct.",
      "<pre><ul>",
      "<li>total = 0\nfor key in people:\n    total += key</li>",
      "<li>total = 0\nfor x in people.values():\n    total += x</li>",
      "<li>total = sum(people.values())</li>",
      "<li>total = 0\nfor key in people:\n    total += people[key]</li>"
    ],
    desc2: "What is:<br/><pre><code>total = 0\nfor key in people:\n    total += key</code></pre>"
  },
  {
    title: "Dictionary Access",
    desc1: ["If we have the same people dictionary as above", 
      "<pre><code>people = {'hugh':49,'kate':35,'lucy':24,'bob':36}</pre></code>",
      "What happens when we try to access the element: <pre><code>people['dan']</code></pre>",
      "<ul><li style='text-align: left'>Since 'dan' is not a value in the dictionary, Python raises a KeyError exception.</li>",
      "<li style='text-align: left'>Since 'dan' is not a value in the dictionary, Python raises a KeyError exception.</li>",
      "<li style='text-align: left'>It is executed fine, no exception is raised, and it returns the Python key value None.</li>",
      "<li style='text-align: left'>Since 'dan' is not a key in the dictionary, Python raises a syntax error.</li><ul>"
    ],
    desc2: "What is:<br/>Since 'dan' is not a key in the dictionary, Python raises a KeyError exception."
  },
  {
    title: "Dictionary Filtering",
    desc1: ["Suppose we have the following list of dictionaries and associated loop of code.<br/>",
      "<pre><code>peoplelist = [{'name':'Taylor','age':28},{'name':'Swift','age':43},{'name':'cat','age':17}]",
      "for item in peoplelist:",
      "    if item['age']>30:",
      "       print(item['name'])</pre></code>",
      "What will be the result if we execute this code?",
      "<pre><ul>",
      "<li>Taylor Swift</li>",
      "<li>('Swift',43)</li>",
      "<li>Taylor</li>",
      "<li>('name:':'Taylor')</li></ul></pre>"      
    ],
    desc2: "What is: Taylor"
  },
  {
    title: "Syntax",
    desc1: ["This is the reason developers stare at their screen for 20 minutes before realizing they forgot one space."     
    ],
    desc2: "What is: Indentation"
  },
  {
    title: "Useless Function",
    desc1: ["Suppose we define the following mystery function:<br/>",
      "<pre><code>def mystery(x):",
      "if x > 0:",
      "    return −x",
      "else:",
      "    return x</pre></code>",
      "Which of the following is NOT a true statement?",
      "<pre><ul>",
      "<li>Calling mystery(0) returns −5.</li>",
      "<li>Calling mystery(5) returns −5.</li>",
      "<li>Calling mystery(−5) returns −5.</li>",
      "<li>Calling mystery(0) returns 0.</li></ul></pre>"      
    ],
    desc2: "What is: <pre><code>Calling mystery(0) returns −5</code></pre>"
  },
  {
    title: "numpy Arrays",
    desc1: ["Suppose we define a NumPy array from a list of lists: (Please note that the print statement leaves out commas between elements in the array below.):<br/>",
      "<pre><code>import numpy as np",
      "c = np.array([[2,4,6,8],[12,14,16,18],[22,24,26,28]])",
      "print(c)",
      "[[2,4,6,8]",
      "[12,14,16,18]",
      "[22,24,26,28]]</pre></code>",
      "What is the shape of this array as defined by c.shape?",
      "<pre><ul>",
      "<li>(4,3)</li>",
      "<li>(2,3)</li>",
      "<li>(3,2)</li>",
      "<li>(3,4)</li></ul></pre>"      
    ],
    desc2: "What is: (3,4)"
  },
  {
    title: "numpy Array Slicing",
    desc1: ["If we have the same NumPy array c as defined in the previous question, how would we index the array using slices to get the second row [12,14,16,18]:<br/>",
      "<pre><code>import numpy as np",
      "c = np.array([[2,4,6,8],[12,14,16,18],[22,24,26,28]])",
      "<pre><ul>",
      "<li>c[:,1]</li>",
      "<li>c[1,:]</li>",
      "<li>c[2,:]</li>",
      "<li>c[:,2]</li></ul></pre>"      
    ],
    desc2: "What is: c[1,:]"
  },
  {
    title: "Vectorized Assignment",
    desc1: ["Suppose we define a NumPy array:<br/>",
      "<pre><code>d = np.array([6,16,26])</pre></code>",
      "How would you use a Boolean mask to assign all the values greater than 10 to be the value 0?",
      "<pre><ul>",
      "<li>d = 0</li>",
      "<li>d[d<=10]=0</li>",
      "<li>d[d>10]=0</li>",
      "<li>d[d>10]=d</li></ul></pre>"      
    ],
    desc2: "What is: d[d>10]=0"
  },
  {
    title: "Performance",
    desc1: ["This is the reason your script takes 14 minutes instead of 0.14 seconds."     
    ],
    desc2: "What is: using Python loops instead of vectorization"
  },
  {
    title: "Datetimes",
    desc1: ["Suppose we use the datetime package to create two datetime objects:<br/>",
      "<pre><code>D1 = datetime(2017,2,22,9,30)",
      "D2 = datetime(2017,2,23,10,45)</pre></code>",
      "Which of the following are operations you can do with the datetime objects?",
      "<pre><ul>",
      "<li>Compare the two dates to see which is earlier: D1 < D2</li>",
      "<li>Subtract the two dates to get a timedelta object: D1−D2</li>",
      "<li>Use the function strftime to convert a datetime object to a formatted string</li>",
      "<li>All of these</li></ul></pre>"      
    ],
    desc2: "What is: All of these"
  }
  ];
