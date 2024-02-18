# local-llama

## Here's what we're doing today

- [ ] Turning LLama2-7B into a ported Apple Watch app for a local LLM.
- [ ] https://github.com/Sigil-Wen/WatchGPT2
- [ ] GPT2 was able to be localized for a LLM so let's bump it up and try LLama2 


### Hardware Constraints

- Pretty sure this thing has like 64gb storage, ~1.5/2gb RAM, 4 core neural engine or whatever the hell that is.
- GPT 2 was about 1.5B params in size, so we need to shoot for something in that size, the original GPT2 model was also quantized. So give that some thought.
- https://github.com/huggingface/swift-transformers 


### Game Plan So Far:

- We can get Microsoft's Phi which is about a ~2.7B param model, 1.6GB at FP16
- https://github.com/ggerganov/llama.cpp/discussions/4167
  - From here we can see roughly speaking we can cut our model size in half FP16 to FP8 to FP4 (which is even smaller)
  - Roughly speaking, 1.6GB FP 16 --> 0.8GB FP8 --> 0.4GB FP4
- Honestly though, 1.6GB at FP16 would put us right in the range for execution for iOS...?
