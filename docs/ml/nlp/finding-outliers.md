---
hero: <i class="fa fa-share-alt"></i> Machine learning
keywords: centroid, corpus, document, feature, kdb+, learning, machine, nlp, q, similarity, vector
---

# Finding outliers, and representative documents

The _centroid_ of a collection of documents is the average of their feature vectors. As such, documents close to the centroid are representative, while those far away are the outliers. Given a collection of documents, finding outliers can be a quick way to find interesting documents, those that have been mis-clustered, or those not relevant to the collection.
	
The emails of former Enron CEO Ken Lay contain 1124 emails with a petition. Nearly all of these use the default text, only changing the name, address and email address. To find those petitions which have been modified, sorting by distance from the centroid gives emails where the default text has been completely replaced, added to, or has had portions removed, with the emails most heavily modified appearing first.


### `.nlp.compareDocToCentroid`

_Cosine similarity of a document and a centroid, subtracting the document from the centroid_

Syntax: `.nlp.compareDocToCentroid[centroid;document]`

Where 

-   `centroid` is the sum of all documents in a cluster which is a dictionary 
-   `document` is a document in a cluster which is a dictionary 

returns the cosine similarity of the two documents as a float.
```q
q)petition:laycorpus where laycorpus[`subject] like "Demand Ken*"
q)centroid:sum petition`keywords
q).nlp.compareDocToCentroid[centroid]each petition`keywords
0.2374891 0.2308969 0.2383573 0.2797052 0.2817323 0.3103245 0.279753 0.2396462 0.3534717 0.369767
q)outliers:petition iasc .nlp.compareDocToCentroid[centroid]each petition`keywords
```


## Searching

Searching can be done using words, documents, or collections of documents as the query or dataset. To search for documents similar to a given document, you can represent all documents as feature vectors using TF-IDF, then compare the cosine similarity of the query document to those in the dataset and find the most similar documents, with the cosine similarity giving a relevance score. 
 
The following example searches using `.nlp.compareDocs` for the document most similar to the below email where former Enron CEO Jeff Skilling is discussing finding a new fire chief.
```q
q)queryemail:first jeffcorpus where jeffcorpus[`text] like "Fire Chief Committee*"  
q)-1 queryemail`text;
q)mostsimilar:jeffcorpus first 1_idesc .nlp.compareDocs[queryemail`keywords]each jeffcorpus`keywords

Select Comm AGENDA - Jan 25-Febr 1

Houston Fire Chief Selection Committee Members: Jeff Skilling - Chairperson, 
Troy Blakeney, Gerald Smith, Roel Campos and James Duke.

Congratulations selection committee members! We have a very important and 
exciting task ahead of us. 

On the agenda for the next week are two important items - (1) the Mayor's 
February 1 news conference announcing the Houston Fire Chief selection 
committee and its members; and (2) coordination of an action plan, which we 
should work out prior to the news conference.

News Conference specifics:
speakers - Mayor Brown and Jeff Skilling
in attendance - all selection committee members
location - Fire Station #6, 3402 Washington Ave.
date - Thursday, February 1, 2001
time - 2pm
duration - approximately 30 minutes

I'd like to emphasize that it would be ideal if all selection committee 
members were present at the news conference. 

I will need bios on each committee member emailed to me by close of business 
Monday, January 29, 2001. These bios will be attached to a press release the 
Mayor's Office is compiling.

Coordination of action plan:
Since we have only 1 week between now and the news conference, Jeff has 
proposed that he take a stab at putting together an initial draft. He will 
then email to all committee members for comments/suggestions and make changes 
accordingly. Hope this works for everyone - if not, give me a call 
(713)-345-4840.

Thanks,
Lisa
```



