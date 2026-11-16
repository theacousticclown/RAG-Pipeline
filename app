
import streamlit as st

from rag import answer

st.set_page_config(page_title="RAG Chatbot", page_icon="💬")
st.title("💬 Document Q&A Chatbot")

if "messages" not in st.session_state:
    st.session_state.messages = [] 

for m in st.session_state.messages:
    with st.chat_message(m["role"]):
        st.markdown(m["content"])

if query := st.chat_input("Ask something about your documents..."):
    with st.chat_message("user"):
        st.markdown(query)

    with st.chat_message("assistant"):
        with st.spinner("Searching documents..."):
            reply, hits = answer(query, st.session_state.messages[-6:])
        st.markdown(reply)
        with st.expander("Sources"):
            for h in hits:
                st.caption(f"{h['source']} — page {h['page']} (distance {h['distance']:.2f})")
                st.write(h["text"][:400] + "...")

    st.session_state.messages += [
        {"role": "user", "content": query},
        {"role": "assistant", "content": reply},
    ]