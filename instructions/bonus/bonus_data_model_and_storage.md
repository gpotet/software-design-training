# Bonus: Data model and storage

As you may have noticed, we use a single `items` table to store products, while they have distinct attributes.

So, let's explore a prequel before specific product details were added and decide how we can store data.
For this you can checkout the branch [old-version-with-modeling-iteration](https://github.com/doctolib/software-design-training/blob/old-version-with-modeling-iteration/instructions/iteration1.md) and have a look at iteration 1.

You can also try to change directly the storage approach in your current implementation.

How much does the storage implementation impact the rest of the code? Would it scale well for a large codebase? Can you figure ut a way to reduce this impact to almost nothing?
<details>
<summary>Solution: possible approaches</summary>

If you want to have a look at different possible approaches, we provided 3 branches:
* `main` uses a common table
* `data-model-detail-tables` uses a main table and distinct tables for type specific details
* `data-model-independent-tables` uses three totally distinct tables

</details>

