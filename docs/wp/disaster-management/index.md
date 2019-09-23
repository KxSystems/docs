---
title: ESA Frontier Development Lab Disaster Management using Social Media
description: In this paper, we examine the use of deep learning methods to predict the content of tweets relating to natural disasters and more specifically flooding events. This is done in two parts firstly the training of a binary classifier to discern relevant vs irrelevant tweets and following this a categorical classifier to label the content into finer grained buckets. This classifier is then deployed on a kdb+ feedhandler/tickerplant architecture to allow for live classification of tweets. This task makes use of the kdb+ technology stack for the triaging of tweets using a feedhandler, embedPy to train a model and aspects of the NLP and machine learning toolkits for the preprocessing of data and scoring of results.
author: Conor McCarthy
date: October 2019
keywords: kdb+, q, space, NASA, machine learning
---

# ESA Frontier Development Lab: Analysing social media data for disaster management


The European Space Agency (ESA) Frontier Development Lab (FDL) is an applied artificial intelligence (AI) research accelerator, hosted by both the ESA Centre for Earth Observation and Oxford University. The programme brings commercial and private partners together with researchers, to solve challenges in the space science sector using AI techniques and cutting edge technologies.

[ESA FDL 2019](https://fdleurope.org/fdl-europe-2019) focused on three main areas of research – Atmospheric Phenomena and Climate Variability, Disaster Prevention Progress and Response, and Ground Station Pass Optimization for Constellations. This paper will focus on the second of these challenges and more specifically the response aspect of flood management.

## Project Overview

Annually flooding events worldwide affect on the order of 80 million people, both, in the developed and developing world. Such events create huge social and logistical problems for first responders and interested parties including both governmental and non-governmental organisations. There are limitations within these groups associated with the ability to reliably contact affected individuals and maintain up to date information on the extent of flood waters. These issues in particular pose challenges to effective resourcing and efficient response. 

The primary goal of the European research team focussing on disaster management was to investigate the use of AI to improve the capabilities of organisations to respond to flooding using orbital imagery and social media data. The central problem tackled by the team was the development of deep learning algorithms to map flood extent for deployment on a [CubeSat](https://en.wikipedia.org/wiki/CubeSat) satellite. This project used a [VPU](https://en.wikipedia.org/wiki/Vision_processing_unit) microprocessor chip in the hopes that a neural network architecture could be embedded on the chip, thus allowing for on the edge mapping of floods on cheap satellite systems. The cost of such satellites is on the order of 100 times cheaper than a typical imaging satellite thus allowing a larger number to be deployed for tailored purposes such as flood mapping.

Given the use of extremely specialized hardware for this task a complementary project to this work was designed to leverage kdb+ and the machine learning and interfaces libraries which have become available in the last number of years. In this paper, we examine the use of deep learning methods to predict the content of tweets relating to natural disasters and more specifically flooding events. The purpose of this being to allow concerned parties to filter tweets and thus contact individuals based on their needs. 

This project was seen as being complementary to the CubeSat project for a number of reasons. Firstly, tweets sourced from the twitter API often contain gps information thus providing locations for the CubeSats' to focus the production flood maps. Secondly, the flood maps provided can give first responders and NGO's information about which affected areas to avoid during by flood event.

This work is completed in two distinct sections,

1.  The training of a binary classifier to discern relevant vs irrelevant tweets and following this a multi-class model in an attempt to label the tweets according to sub-classes including but not limited to:
	1.  Affected Individuals.
	2.  Infrastructural damage. 

2.  Deploy the multi-class model on a kdb+ tickerplant architecture to produce a framework for the live classification and querying of tweets. 


All development was done with the following software versions

software | version
-------- | -------
kdb+     | 3.6
Python   | 3.7.0

Python modules used and associated versions are as follows

library        | version
-------------- | -------
beautifulsoup4 | 4.5.3
keras          | 2.0.9
numpy          | 1.16.0
pickle         | 4.0
spacy          | 2.0.18
wordcloud      | 1.5.0

In addition to this a number of kdb+ libraries and interfaces were leveraged

library/interface | Release
----------------- | -------
EmbedPy           | 1.3.2
JupyterQ          | 1.1.7
ML-Toolkit        | 0.3.2
NLP               | 0.1


## Data

The data used for this work was sourced from the [Crisis NLP](https://crisisnlp.qcri.org) datasets. This datasource contains human annotated tweets collected from twitter and relating directly to a wide variety of crises. These crises range from earthquakes and virus outbreaks to typhoons and war events. The data which is of interest within this use case is that relating to floods, for this, flood data from the following events was chosen.

1. 2012 Phillipines
2. 2013 Alberta, Canada 
3. 2013 Colorado, USA
4. 2013 Queensland, Australia
5. 2014 India
6. 2014 Pakistan

These floods are used both as a result of the availability of the datasets themselves, but they also provide geographical and socio-economic variability in the data relating to those affected. In total the dataset contains approximately 8,000 tweets. The data comes from two distinct macro datasets which contain both the tweet text and the classifications of these tweets. Following preprocessing to standardize the classes across the datasets the following are the sub-classes used within the multi-class section of this project.

1. Affected Individual
2. Sympathy and Prayers
3. Infrastructure or Utilities
4. Caution and Advice
5. Other Useful information
6. Donations and Volunteering
7. Useless Information


## Modelling Issues in social media data

Dealing with social media data and in particular twitter data poses a number of problems for producing reliable machine learning models.

1. The first of these issues is the [character limit of tweets](https://techcrunch.com/2018/10/30/twitters-doubling-of-character-count-from-140-to-280-had-little-impact-on-length-of-tweets/?guccounter=1&guce_referrer_us=aHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS8&guce_referrer_cs=rbvyYOiaknVKOAxueczesw), while this has been increased over the years to 280 characters the median character length is 33 characters. This creates the potential that a tweet acts as a 'noisy' dataset due to the lack of a clear discernable signal, thus making it difficult to derive meaning from the tweet.

2. The ambiguity of language also poses an issue. The same phrase in different contexts can have wildly different meanings, for example, if an individual was to tweet “I just got free ice-cream and now looking forward to the theatre later. How much better could my day get?” vs someone tweeting "It's been raining all day and I missed my bus. How much better could my day get?", clearly the first use of better is positive while the second is negative, the information about which is encoded in each case for the user in the first sentence.

3. Colloquialisms and the names of locations can also pose an issue. One of the most important target categories being used here is infrastructure and utilities. This target has a strong association with place names. For example "Terrible to see the damage on the Hoover due with the flooding in Colorado", for anyone that's aware of the Hoover Dam in Colorado it is clear that there is likely infrastructural damage to the Dam. However a computer will likely to miss this without context.

These are just a small number of potential issues which can arise when dealing with social media data but can be rectified in the following manner.

1. Dealing with noise is handled in the preprocessing step through the removal of emojis, email links etc. The decisions made here both can improve the ability to classify the data through standardizing the text but can also remove important information if taken to too extreme a level.            

2. Both the 2nd and 3rd issues are mitigated against through the use of a model or techniques which have an understanding of the ordering of language. For example in the sake of the "Hoover dam" example knowing that the words "damage" and "terrible" preceded the word "Hoover" may indicate that there has been some infrastructural damage. The use of a model to solve this issue is presented within this white-paper

## Pre-processing

To highlight the need to pre-process the data being used in this paper the following are examples of some tweets within the corpus

```q
// tweet contains user handle with leading at symbol and numeric values
1. "rescueph @cesc_1213: please help us seek rescue for our friend!:( Jala Vigilia, 09329166833"

// tweet contains hashtags, times and numeric values
2. "river could now reach 15-metre flood peak after midnight (it's 11:05pm up here). bundaberg still the big #dangerzone#flooding"

// tweet contains url and emojis 
3. "Colorado flooding could help keep tourists away http://t.co/vqwifb51hk Denver\342\200\224a"
```

For this work the following steps were taken to standardise the data being presented to the model

1. Remove all capitalization by lowering each tweet
2. Remove full stops, commas and other common single character.
3. Replace hashtags with a space allowing individual words to be taken out of the tweet hashtags.
4. Remove emojis from the tweets.
5. Remove the 'rt' tag.
6. Remove the at symbol indicating user name.

The code to achieve this in its entirety is wrapped in several helper functions within `code/fdl_disasters.q` and is executed as follows within the notebook provided.

```q
q)rmv_list   :("http*";"rt";"*,";"*&*";"*[0-9]*")
q)rmv_single :rmv_master[;",.:?!/@'";""]
q)rmv_hashtag:rmv_master[;"#";""]

q)data_m[`tweet_text]:data_b[`tweet_text]:(rmv_ascii rmv_custom[;rmv_list] rmv_hashtag rmv_single@) each data_m`tweet_text
```

Taking these changes into account the tweets above are transformed into the following

```q
1. "rescueph cesc please help us seek rescue for our friend jala vigilia"

2. "river could now reach metre flood peak after midnight its up here bundaberg still the big dangerzone flooding"

3. "colorado flooding could help keep tourists away denver"
```

## Data Exploration

When producing a machine learning model it is important to understand the content of the data being used. Doing so provides us with the ability to choose and tune an appropriate model to apply. This is heavily influenced by an understanding of how the target data is distributed and what information is contained in the data itself.

### Data Distribution
Firstly we look at the distributions of the targets in the binary example:

```q
q)distrib_b:desc count each group data_b`target

q)plt[`:bar][til count distrib_b;value distrib_b;`color pykw `b];
q)plt[`:title][`$"Distribution of target categories within binary-class dataset"];
q)plt[`:xlabel][`Category];
q)plt[`:xticks][til count distrib_b;key distrib_b;`rotation pykw `45];
q)plt[`:ylabel][`$"#Tweets"];
q)plt[`:show][];
```

![Figure 1](imgs/binary_dist.png)

We can see from this that the dataset contains significantly more of the affected individuals class which given the dataset being used in unsurprising.

Looking at the multi-class example we can see how the dataset as a whole breaks down into categories, the code to do so is similar to that above and thus not displayed again.

![Figure 2](imgs/multi_dist.png)

As with the binary case there are a number of classes that are more prominent within the data namely the affected individuals and donations/volunteering for example and some classes that are seen less often i.e. sympathy and prayers.

### Word Cloud

Similar to the data distribution case it is possible to gain some insights into the content of the dataset by looking at commonly occurring words within the classes. This is completed through the use of the wordcloud library in Python. The code to achieve this is wrapped in the function `wordcloud` which functionally is as follows

```q
args:`background_color`collocations`min_font_size`max_font_size
vals:(`white;0b;10;90)
wordcloudfn:{
 cloud:z[`:generate]raze(?[x;enlist(=;`target;enlist y);();`tweet_text]),'" ";
 plt[`:figure][`figsize pykw (10;20)];
 plt[`:title]["keywords regarding ", string y];
 plt[`:imshow][cloud;`interpolation pykw `bilinear];
 plt[`:axis]["off"];
 plt[`:show][];}[;;wcloud[pykwargs args!vals]]

// execution of this code is completed as follows
q)wordcloudfn[data_m;`donations_volunteering]
```

This produces the following output

![Figure 3](imgs/Affected_individuals.png)

In the above example, surrounding the affected individuals class, it is clear that tweets in this category contain some distinguishing characteristics. For example words such as death, killed, missing and rescue all are associated with people who have had their lives disrupted by flooding. Meanwhile words contained in the sympathy and prayers class, use language strongly relating to religion as seen below.

![Figure 4](imgs/Sympathy_prayers.png)  

This indicates that while words such as "flood" and "kashmir" are prominent in tweets associated with each class there are words which seem to indicate the base class of the tweets themselves.

### Sentiment Analysis

The final step in the data exploration phase was to look at the positive and negative sentiment of tweets within the corpus. This is achieved using functionality within the NLP library released by Kx. The code for which is as follows

```q
q)sentiment:.nlp.sentiment each data_m`tweet_text
// Positive tweets
q)3?100#data_m[`tweet_text] idesc sentiment`compound
"request to all twitter friends pray and help the flood victims of pakistan request to all are politicians kindly build dams"
"joydas please use kashmir flood hashtag only if u need help or offering help so that agencies can track keep it free from ur politica"
"south ab flood relief fund supports local charities that help those impacted by abflood give at cc druhfarrell"
// Negative tweets
q)3?100#data_m[`tweet_text] iasc  sentiment`compound
"news update floods kill in eastern india new delhi - flooding in eastern india has killed bangkokpost"
"in qlds criminal code stealing by looting subs carries a max penalty of years jail bigwet qldfloods"
"at least dead in colo flooding severe flooding in jamestown in colorados boulder county killed one person"
```

This allows us to gain insights into of the state of mind of individuals who are tweeting and an understanding of some of the characteristics which may come to be associated with individual classes. For example the positive tweets above, both offer the sympathy and donations whereas the negative tweets talk about the death of individuals and criminal activity. This can have a bearing on how tweets get classified based on the absence or presence of specific words or phrases.


## Model

The model which has been applied to both the binary and multi classification problems is a Long short-term memory(LSTM) model. This type of deep learning architecture is a form of recurrent neural network(RNN). Its use stems from the need to gain an understanding of the ordering of words within the tweets such that context can be derived. 

To gain this understanding, the model uses a structure known as a memory cell to regulate weights/gradients within the system, commonly RNNs suffer issues with [exploding](https://machinelearningmastery.com/exploding-gradients-in-neural-networks/) or [vanishing](https://towardsdatascience.com/the-vanishing-gradient-problem-69bf08b15484) gradients during back propagation but these are mitigated against through the memory structure of the model.

The following is a pictorial representation of an LSTM cell with the purpose of each gate outlined

![Figure 5](imgs/lstm_memorycell.png) 

*  Input Gate: Controls how new information flows into the cell
*  Forget Gate: Controls how long a value from the input gate stays in the cell (memory)
*  Output Gate: Controls how the cell value is used to compute the activation of an LSTM unit


### Model Structure

Producing an LSTM model can be done in embedPy using Keras. The following is the model used for the multi-class use case in this paper

```q
// Define python functionality to produce the model
q)kl:{.p.import[`keras.layers]x}
q)seq    :.p.import[`keras.models]`:Sequential
q)dense  :kl`:Dense
q)embed  :kl`:Embedding
q)lstm   :kl`:LSTM
q)spdrop1:kl`:SpatialDropout1D
q)dropout:kl`:Dropout

// Create the model to be fit
q)mdl_m:seq[];
q)mdl_m[`:add][embed[2000;100;`input_length pykw (.ml.shape X)1]];
q)mdl_m[`:add]spdrop1[0.1];
q)mdl_m[`:add]lstm[100;pykwargs `dropout`recurrent_dropout!(0.1;0.1)];
q)mdl_m[`:add]dense[7;`activation pykw `sigmoid];
q)mdl_m[`:compile][pykwargs `loss`optimizer`metrics!(`categorical_crossentropy;`adam;enlist `accuracy)];
q)print mdl_m[`:summary][];
```

The summary of this model is as follows:

![Figure 6](imgs/LSTM_model.png)

A few points of note on this model:

*  A number of forms of dropout are used to prevent model overfitting.
*  The dense layer contains seven nodes, one associated with each of the output classes in the multi-class example.
*  The number of LSTM units chosen was 100, these are 100 individual layers with independent weights.
*  The loss function used is a categorical cross-entropy to account for the target being categorical and non-binary.

### Model Data preparation

Prior to fitting this model a number of steps must be taken to manipulate the data such that it can be 'understood' by the LSTM and scored correctly.

Due to how computers handle information the data cannot be passed to the model as strings or symbols, instead it must be encoded numerically. This can be achieved through a number of methods including, but not limited to, tokenization and one-hot encoding both of which are used here.

Tokenization in Natural Language Processing is the splitting of data into distinct pieces known as tokens. These tokens provide natural points of distinction between words within the corpus and thus allow the text to be converted into numerical sequences. 

This conversion was completed as follows using keras text processing tools on the tweets:

```q
// Python text processing utilities
q)token:.p.import[`keras.preprocessing.text]`:Tokenizer
q)pad  :.p.import[`keras.preprocessing.sequence]`:pad_sequences

// Set the maximum number of important words in the dataset
q)max_nb_words:2000
// Set the maximum allowable length of a tweet (in words)
q)max_seq_len :50

// Convert the data to a numpy array
q)tweet_vals :npa data_b`tweet_text

// Set up and fit the tokenizer to create the numerical sequence of important words
q)tokenizer:token[`num_words pykw max_nb_words;`lower pykw 1b]
q)tokenizer[`:fit_on_texts]tweet_vals;

// Convert the individual tweets into numerical sequences
q)X:tokenizer[`:texts_to_sequences]tweet_vals
```

Finally once the data has been converted into numerical sequences it must be 'padded' such that the input length of each of the tweets is the same. This consistency is required to ensure the neural network is passed consistent lengths of data. Padding here refers to the addition of leading zeros to the numeric representation of the tweets such that each is a list of 50 integers. 

The display of the tweets below is truncated to ensure that the final values can be seen.

```q
q)X:pad[X;`maxlen pykw max_seq_len]`
// display the integer representation of the tweets
q)5#{30_x}each X
0 0   0   0  0   0   0   0    0    0    0    0    0    732 12   1    141 24   42   758 
0 0   0   0  0   649 2   90   158  520  308  252  1    57  501  1357 733 7    1631 1079
0 0   0   0  0   0   0   0    0    0    0    158  380  12  50   201  7   24   16   141 
0 0   0   0  0   0   0   0    0    0    0    0    0    0   0    732  12  1    141  24  
0 0   0   0  216 6   233 63   3    116  1    141  99   195 68   138  3   9    290  90 
```

As mentioned above one-hot encoding can also be used to create a mapping between text and numbers. As the target categories themselves are symbols these must be encoded, this is done using a utility function contained within the [machine-learning toolkit](https://github.com/kxsystems/ml).

```q
q)show y:data_m`target
`sympathy_prayers`other_useful_info`other_useful_info`other_useful_info`sympathy_prayer
q)5#Y_m:flip value ohe_m:.ml.i.onehot1 data_m`target
0 0 0 0 0 0 1
0 0 0 0 0 1 0
0 0 0 0 0 1 0
0 0 0 0 0 1 0
0 0 0 0 0 0 1
```


### Model fitting

Now the categorical and textual data has been converted into a numerical representation it must be split into a training and testing set in order to maintain separation of the data in order to allow the results to be judged fairly, this is completed as follows:

```q
// train-test split binary data
q)tts_b:.ml.traintestsplit[X;Y_b;0.1]
q)xtrn_b:tts_b`xtrain;ytrn_b:tts_b`ytrain
q)xtst_b:tts_b`xtest;ytst_b:tts_b`ytest
// train-test split multi-class data
q)tts_m:.ml.traintestsplit[X;Y_m;0.1]
q)xtrn_m:tts_m`xtrain;ytrn_m:tts_m`ytrain
q)xtst_m:tts_m`xtest;ytst_m:tts_m`ytest
```

With the data split, both the binary and multi-class models can be fit such that new tweets can be classified and the results scored.
```q
// Fit binary model on transformed binary datasets
q)mdl_b[`:fit][npa xtrn_b;npa ytrn_b;`epochs pykw epochs;`verbose pykw 0]
// Fit multi-class model on transformed multi-class data
q)mdl_m[`:fit][npa xtrn_m;npa ytrn_m;`epochs pykw epochs;`verbose pykw 0]
```

## Results

Now that the models have been fit on the training set the results can be scored on the held out test set, the scoring is done in a number of parts:

1. Percentage of correct predictions vs misses per class.

2. Confusion matrix for predicted vs actual class.

3. Classification report outlining precision and recall and f1-score for each class.

This functionality is wrapped in the function `class_scoring` in the `code/fdl_disasters.q` script

```q
// Binary classification prediction and scoring
q)class_scoring[xtst_b;ytst_b;mdl_b;ohe_b]
The following is the integer mapping between class integer representation and real class value:

affected_individuals| 0
not_applicable      | 1

Actual Class vs prediction

Class Prediction Hit
--------------------
0     0          1  
0     0          1  
1     1          1  
0     0          1  
0     0          1  

Displaying percentage of Correct prediction vs misses per class:

Class| Hit       Miss      
-----| --------------------
0    | 0.9550225 0.04497751
1    | 0.6111111 0.3888889 
TOTAL| 0.9070968 0.09290323

Displaying predicted vs actual class assignment matrix:

Class| Pred_0 Pred_1
-----| -------------
0    | 637    30    
1    | 42     66    

Classification report showing precision, recall and f1-score for each class:

class               | precision recall    f1_score  support
--------------------| -------------------------------------
affected_individuals| 0.9381443 0.9550225 0.9465082 667    
not_applicable      | 0.6875    0.6111111 0.6470588 108    
avg/total           | 0.8128222 0.7830668 0.7967835 775    
```

In the case of the binary classifier accuracies in the region of 91% shows that the model was capable of discerning between relevant and irrelevant tweets. More informative however is the recall on the affected individuals class which was 95%, as such we are only missing 5% of the total true positives of affected individuals, in this case recall is the most important characteristic for model performance.

```q
// Multi-class prediction and scoring
q)class_scoring[xtst_m;ytst_m;mdl_m;ohe_m]
The following is the integer mapping between class integer representation and real class value:

affected_individuals    | 0
caution_advice          | 1
donations_volunteering  | 2
infrastructure_utilities| 3
not_applicable          | 4
other_useful_info       | 5
sympathy_prayers        | 6

Actual Class vs prediction

Class Prediction Hit
--------------------
0     0          1  
2     2          1  
2     0          0  
4     4          1  
5     3          0  

Displaying percentage of Correct prediction vs misses per class:

Class| Hit       Miss     
-----| -------------------
0    | 0.8831776 0.1168224
1    | 0.5625    0.4375   
2    | 0.7424242 0.2575758
3    | 0.4756098 0.5243902
4    | 0.7068966 0.2931034
5    | 0.5906433 0.4093567
6    | 0.6666667 0.3333333
TOTAL| 0.6967742 0.3032258

Displaying predicted vs actual class assignment matrix:

Class| Pred_0 Pred_1 Pred_2 Pred_3 Pred_4 Pred_5 Pred_6
-----| ------------------------------------------------
0    | 189    3      6      3      1      6      6     
1    | 3      36     4      4      0      15     2     
2    | 10     3      98     1      4      12     4     
3    | 7      5      7      39     1      22     1     
4    | 1      2      0      0      41     10     4     
5    | 20     16     14     11     3      101    6     
6    | 4      2      4      0      1      7      36    

Classification report showing precision, recall and f1-score for each class:

class                   | precision recall    f1_score  support
------------------------| -------------------------------------
affected_individuals    | 0.8076923 0.8831776 0.84375   214    
caution_advice          | 0.5373134 0.5625    0.5496183 64     
donations_volunteering  | 0.7368421 0.7424242 0.7396226 132    
infrastructure_utilities| 0.6724138 0.4756098 0.5571429 82     
not_applicable          | 0.8039216 0.7068966 0.7522936 58     
other_useful_info       | 0.583815  0.5906433 0.5872093 171    
sympathy_prayers        | 0.6101695 0.6666667 0.6371681 54     
avg/total               | 0.6788811 0.6611312 0.6666864 775    
```

The multi-class example also appears to be working well with overall accuracy of ~70%. Recall in the most important category affected individuals which was ~88%. The most common misclassification was the classification of 'infrastructure/utilities' damage as 'other useful information' which is in many cases is a reasonable miscategorization as outlined in the conclusions section.

## Live-System

As outlined in the results section above the scores produced for the categorization of multi-class tweets has been broadly successful. The conclusions section below will outline the limiting factors which affect the ability to produce a better model. However the results are sufficient to move onto producing a framework which could be used for the live classification of tweets.

The first step is the saving of the tokenizer and model which are to be applied to the data as it is fed through the feed, this is done within the notebook using the following commands

```q
// python script which uses pickle to save tokenizer
q)\l ../code/token_save.p
q)sv_tok:.p.get[`save_token]
q)sv_tok[tokenizer];
// save model as a h5 file
q)mdl_m[`:save]["../live/multiclass_mdl.h5"]
```

Given limited availability to data, data from the notebook is used to produce a 'live' system. 

The outline for this system is based heavily on the 'vanilla' [kdb tickerplant architecture](https://github.com/KxSystems/kdb-tick).

The first step to run the system is to initialize the tickerplant, here the port is being automatically set to 5140, all other port assignments are overwritten

```q
$q tick.q sym ./log/

For the purposes of this example -p must be set to 5140, setting port accordingly

q)
```

Now that the tickerplant is listening for messages from the feedhandler we can start to look at the creation of this feed. The code sections of note within this are the following

```q
// Open a connection to the tickerplant
h:neg hopen`:localhost:5140

// Create a dictionary showing rolling number of tweets per class.
processed_data:{dd:(0#`)!();
 select
  affected_individuals:0,
  caution_advice:0,
  donations_volunteering:0,
  sympathy_prayers:0,
  other_useful_info:0,
  infrastructure_utilities:0,
  useless_info:0
 from dd}[]

// Function to update the appropriate tables on the tickerplant 
// update the number of values classified in each class

upd_vals:{(h(".u.upd";x;y);processed_data[x]+:1)}

// time sensitive data feed 
.z.ts:{
 if[(0=n mod 50)and n>1;
    -1"\nThe following are the number of tweets in each class for ",string[n]," processed tweets";
    show processed_data];
 clean_tweet:(rmv_ascii rmv_custom[;rmv_list] rmv_emoji rmv_hashtag rmv_single@) tweets[n];
 X:pad[tokenizer[`:texts_to_sequences]enlist clean_tweet;`maxlen pykw 50];
 pred:key[ohe]raze{where x=max x}(svd_mdl[`:predict][X]`)0;
 pkg:(.z.N;pred[0];clean_tweet);
 $[pred[0]=`affected_individuals;
   upd_vals[`affected_individuals;pkg];
   pred[0]=`caution_advice;
   upd_vals[`caution_advice;pkg];
   pred[0]=`donations_volunteering;
   upd_vals[`donations_volunteering;pkg];
   pred[0]=`sympathy_prayers;
   upd_vals[`sympathy_prayers;pkg];
   pred[0]=`other_useful_info;
   upd_vals[`other_useful_info;pkg];
   pred[0]=`infrastructure_utilities;
   upd_vals[`infrastructure_utilities;pkg];
   upd_vals[`useless_info;pkg]];
 n+:1;}
```

Looking closely at the feed function above it is clear that this is for the most part following the data pipeline used within the notebook

1. Tweets are purged of ascii characters, emojis, special characters and hashtags

2. The tweets are tokenized and padded to an appropriate length

3. The trained model is used to predict the class of the tweet

The divergence comes once we have classified the tweet at which point, the table appropriate for the class is updated using the `upd.vals` function, in function the time the tweet was classified, the class label and the cleaned tweet are being inserted into to the appropriate tables.

The feed is kicked off at which point the required libraries are loaded into the feed process

```q
$q feed.q
Loading utils.q
Loading regex.q
Loading sent.q
Loading parser.q
Loading time.q
...
// set system to publish a message every 100ms
q)\t 100
```

At this point we can now set up an rdb to allow us to query the tables associated with each class. For the sake of simplicity the rdb in this example is subscribed to all the tables however this could be modified based on use-case

```q
$q tick/r.q -p 5011
q)caution_advice
time                 sym            tweet                                    ..
-----------------------------------------------------------------------------..
0D13:19:27.402944000 caution_advice "abcnews follow our live blog for the lat..
0D13:19:28.898058000 caution_advice "davidcurnowabc toowoomba not spared wind..
0D13:19:31.498798000 caution_advice "acpmh check out beyondblue looking after..
0D13:19:33.797604000 caution_advice "ancalerts pagasa advisory red warning fo..
0D13:19:34.798857000 caution_advice "flood warning for the dawson and fitzroy..
q)donations_volunteering
time                 sym                    tweet                            ..
-----------------------------------------------------------------------------..
0D13:19:27.300326000 donations_volunteering "rancyamor annecurtissmith please..
0D13:19:27.601642000 donations_volunteering "arvindkejriwal all aap mlas to d..
0D13:19:28.198921000 donations_volunteering "truevirathindu manmohan singh so..
0D13:19:29.001481000 donations_volunteering "bpincott collecting donations in..
0D13:19:30.297868000 donations_volunteering "vailresorts vail resorts gives p..
```

## Conclusions

In conclusion it is clear from the results above that the use of an LSTM architecture to create a classifier for tweet content was broadly successful. 

A number of limiting factors hamper the ability to create a better model with the data available, these are as follows:

1. The dataset used was limited in size with only 7,800 classified tweets readily available. Given the 'noisy' nature of tweets this creates difficulties around producing a reliable model. A larger corpus would likely produce a better representation of the language used in flooding scenarios and thus allow a better model to be produced.

2. The human annotated data can be unreliable, while the data was collected and tagged by CrisisNLP given the similarity of some of the classes it may be the case that mistakes being made by the model are accurate representation of the true class. This is certainly true in the case of the data from India and Pakistan where a reference for the quality of the classifications is provided in the raw dataset.

3. Decisions regarding information to remove from the dataset can have an impact, the inclusion of hashtags or the removal of user handles or rt tags can have an impact on the models ability to derive context from the tweets. A search of this parameter space showed that the removal of user names had a negative effect for example. This is likely a result of tweets from news organisations which are prevalent and are more likely to relate to a small number of classes for example infrastructure/utilities and caution/advice.

The production of a framework to 'live' score data was also outlined. As mentioned when discussing the limits in model performance there are also a number of limiting factors with this live system. The processing and classification time for an individual tweet limits the throughput of the system to approximately 40 messages per second in order to scale this system to a larger dataset with higher throughput requirements a more complex infrastructure or simplified machine learning pipeline would be required.

However this system shows the potential for the use of kdb+ in the sphere of machine learning when applied to natural language processing tasks.

## Author

Conor McCarthy joined First Derivatives in March 2018 as a Data Scientist in the Capital Markets Training Program and currently works as a machine learning engineer and interfaces architect in London. 



## Code

The code presented in this paper is available on GitHub at ...


### Acknowledgements

I gratefully acknowledge the help of all those at FDL Europe for their support and guidance in this project and my colleagues on the Kx Machine Learning team for their help vetting technical aspects of this paper.
