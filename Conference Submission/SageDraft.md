The Process of Polarization as a loss of dimensionality

Plan:

* Introduction: (SAGE)

- 1 Page on SOA polarization studies on social networks

- Mention a couple of papers

- Bimodality on 1 (2?) dimensional axis (ideology, or whatever)

- 1 Page on "post-structural says this is bollocks"

- Quote about loss of complexity (Hegemony)

* Methodology (GVDR)

- 1 Page about:

- Social Networks as graphs

- RDPG and SVD embedding, choice of dimensionality <- OUR PROPOSAL

- Test against Von Neumann Entropy, Spectral Gap

* Data (GVDR)

- 1 Page on COP data

(- 1 Page about synthetica data, "perfect matrices")

* Results: PLOTS (1 Page)

- Plot 1: scatter plot of d (svd elbow method) vs cop2x

- Plot 2: comparison of the other metrics

* Discussion / Conclusion (1 Page) (SAGE/GVDR)

- Compare with Quattrociocchi et al methodology, "why is different/the same"

- possible limitations (signed matrices, positive negative interactions)

- link it back to post-structuralism

Social and political polarisation is an issue of increasing concern in the international community, since it is associated with severe social divisions and weakening of the democratic consensus. Much of the research on polarisation is directed at the USA, particularly in the wake of the Trump presidency, but concern about polarisation is also present in European countries, [other example], and even New Zealand.

Definitions of polarisation primarily focus on the presence of a bimodal division in the data, whether it is obvious to the casual observer (e.g. no overlap between the groups) [Heatherington] or shown to be significant using tests such as Hartigan’s Dip test[]. When investigating social networks, this bimodality is expressed as strong in-group/out-group divisions [valenseise], and is often characterised by hostility between the two groups; it is common to consider this hostility as a sign of polarsation, not just the differences in policy positions between the two poles – usually the Republican and Democrat parties in the USA. Another common aspect of current polarisation studies is that the polarised groups are expected to be of equal size, as well as strongly divided, which ought to help tell polarisation conflicts apart from other major social conflicts (e.g. wealth inequalities where a very small group owns most of the wealth) [estban and ray]

Computational data science approaches to measuring polarisation are popular. When investigating social media polarisation, network data often comprises millions of records; computational methods are the most efficient way of managing data of this size, and there are fast and simple algorithms for detecting communities that can then be investigated for polarisation [Louvain]. As mentioned, statistics methods allow researchers to quantify the level of division in bimodal data, which helps solve questions of whether the data is meaningfully polarised.. In other cases, clustering algorithms are more appropriate than bimodality tests; there are a number of ways of measuring distances between the clusters, which can indicate polarisation between the groups if the clusters also have low internal variation.

In this paper we choose a different definition of polarisation, based on the work of the political theorists Ernesto Laclau and Chantal Mouffe. In their book Hegemony and Socialist Strategy[], they seek to understand how the “antagonisms” that drive major political shifts such as revolutions occur. Their description of the extreme division created by “populist antagonisms” both gives us a strong theory of what polarisation is and clearly explains the mechanism by which it occurs.

Laclau and Mouffe find two kinds of “antagonisms”: a pluralistic “democratic antagonism”, and a “populist antagonism” that arises out of extreme, polarised division between two groups.

It would appear that an important differential characteristic may be established between advanced industrial societies and the periphery of the capitalist world: in the former, the proliferation of points of antagonism permits the multiplication of democratic struggles, but these struggles, given their diversity, do not tend to constitute a ‘people’, that is, to enter into equivalence with one another and to divide the political space into two antagonistic fields. On the contrary, in the countries of the Third World, imperialist exploitation and the predominance of brutal and centralized forms of domination tend from the beginning to endow the popular struggle with a centre, with a single and clearly defined enemy. Here the division of the political space into two fields is present from the outset, but the diversity of democratic struggles is reduced. (131)

Laclau and Mouffe say that the cause of populist antagonism is the segregation of the social, political, material, and cultural fields so that everything is associated with one of the poles (and cannot be associate with the opposing pole).

In a colonized country, the presence of the dominant power is every day made evident through a variety of contents: differences of dress, of language, of skin colour, of customs. Since each of these contents is equivalent to the others in terms of their common differentiation from the colonized people, it loses its condition of differential moment, and acquires the floating character of an element. [...] the colonizer is discursively constructed as the anti-colonized. (128)

Simply put, the segregation consumes the social and cultural network until all other differences are either aligned with the segregating divide or rendered irrelevant.

Applying this understanding to data science, we believe that the process of polarisation that Laclau and Mouffe describe corresponds to a loss of dimensionality in the social network. In a non-polarised social network, the dimensionality is very high; there are many things influencing whether a person will connect with another person. The goal of polarisation is to produce a society where the only determinant of whether two people connect is whether they belong to the same pole or not, i.e. it is the only dimension determining the shape of the network. As such, decreasing dimensionality in a social network, especially decreasing to d=2, should indicate that this network is becoming polarised.

We prefer this approach to polarisation over others used in data science because it has greater flexibility: the poles do not have to be equal in size or power, and Laclau and Mouffe stress that polarisation is often the result of one pole oppressing and subordinating the other. It is also stricter than many other approaches; most “echo chamber” effects, while detrimental to participants, do not create a deep enough divide in the mass society to qualify as a populist antagonism. However, we think it is useful to focus on the most severe cases, as these are the ones most likely to soon erupt into civil war, violence and oppression.

[methodology]

[data]

[discussion]

One of the limitations of this approach is that it does not capture whether interactions between the groups are positive or negative. in cases where the polarisation includes oppression and subordination, there are often negative interactions between the groups that increase the hatred between them and reinforce the segregation. Using an unsigned matrix means that we cannot tell whether an interaction between the groups is positive and reducing polarisation, or is negative and increasing it. This is one of the ways that real-life examples of polarisation will never reach the theoretically possible “maximum polarisation”. 