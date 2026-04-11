# Paper Summary Rules

Use this file for the paper-specific summarization structure that is layered on top of the base Notion page rules.

## Core Instructions

- Read the paper.
- Update the Notion page according to your explanation about the paper.
- First read the Notion page and understand the page structure and table of contents.
- Follow the instructions on the Notion page and fill the content into the relevant sections.
- Write the paper summary as if you are the researcher, not as if you are explaining it to someone else.
- Write the content in Korean.
- When an abbreviation appears in the paper summary, expand it on first mention as `[abbreviation](full expression)`.
- Resolve each abbreviation from the paper's own context, not from the most common expansion in some other field.
- If the paper never makes the expansion recoverable, avoid inventing one. Either keep the surrounding sentence abbreviation-free or use only the form that is explicitly supported by the source.
- If temporary downloads or extracted paper files were created while preparing the summary, remove them before finishing the task.

## Abbreviation Examples

Use the following style when the paper context supports these expansions:

- `[MRC](Machine Reading Comprehension)` dataset setup is used to frame the multi-hop question answering task.
- `[RAG](Retrieval-Augmented Generation)` pipeline combines retrieval and generation in the proposed system.
- `[DPR](Dense Passage Retrieval)` retriever is used as the dense retrieval baseline.
- `[NLI](Natural Language Inference)` supervision is used to evaluate whether the evidence supports the claim.
- `[RLHF](Reinforcement Learning from Human Feedback)` stage is introduced to align the model with human preferences.

## Section Rules

### Abstract

- Briefly summarize the abstract of the paper.

### Introduction

- Read the introduction of the paper and answer the questions provided on the Notion page.
- Answer the following when the page asks for them:
  - question 1: motivation of this paper
  - question 2: the problem to be solved
  - question 3: what the proposed method improves
  - question 4: how much performance has improved
  - question 5: main contributions
- If question 4 is not stated in the paper, skip it instead of inventing a number.

### Related Work

- Organize each mentioned paper as `[Title, First Author et al., Year]`.
- Summarize the content of that paper in one line.
- Summarize its relevance to the present study in one additional line.

### Main Methods

- Summarize the core methodology proposed in the paper.
- Focus on the training process, model architecture, or the overall workflow of the model.
- Use diagrams, Mermaid, or pseudocode only when the relevant structure appears in the paper body or appendix.

### Experiments

- Treat this as the most important and detailed section.
- Describe the dataset.
- Specify what dataset was used.
- If the authors built the dataset, summarize how it was constructed.
- If the dataset was collected externally, summarize what was collected and from where.
- Clearly explain the full process from input to output.
- State the type and contents of the inputs.
- State the type and contents of the outputs.
- Summarize the authors' claims, evidence, and interpretation of the results.
- Reproduce result tables only when the paper includes them.

### Conclusion

- Summarize the limitations, claims, and conclusions presented in the paper.

## Fallback Rules

- If arXiv HTML is unavailable or insufficient, write only what can be supported from the abstract.
- If an expected section is absent from the paper, keep that section concise or leave it unfilled rather than guessing.
- If the Notion page already contains substantive content in a section, do not overwrite it unless the user explicitly asks.
