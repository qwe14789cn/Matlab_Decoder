import streamlit as st
from pathlib import Path
import os
import time

st.set_page_config(page_title = 'MATLAB_decoder',page_icon="😺")
st.title("MATLAB *.p Decoder")
with st.form(key="Form :", clear_on_submit = True):
    File = st.file_uploader(label = "Upload file", type=["p"])
    Submit = st.form_submit_button(label='Submit')

if Submit :
    st.markdown("**The file is sucessfully Uploaded.**")

    # Save uploaded file to 'F:/tmp' folder.
    save_path = Path('.\\encode', File.name)
    with open(save_path, mode='wb') as w:
        w.write(File.getvalue())

    if save_path.exists():
        st.success(f'File [{File.name}] is successfully saved!')
        order = f"ipython ./encode/P_decoder.py ./encode/{File.name}"
        os.system(order)

        with st.spinner('Please wait ...'):
            time.sleep(2)
            #如果文件存在 解密成功
            if os.path.exists('.//encode/'+File.name+'.m'):
                st.success(f'✔️File [{File.name}.m ] is successfully converted!')
                col1,col2 = st.columns(2)
                #col1.image('./pay.png',width= 300)
                with open('.//encode/'+File.name+'.m', "rb") as file:
                    st.markdown('---')
                    st.code(file.read().decode('utf-8'),language='matlab',line_numbers=True)

#                        st.code(file.readlines.decode('utf-8'), language="matlab", line_numbers=False)
                    #btn = st.download_button(label="Download decoder file",data=file,file_name=File.name + '.m')
            else: #否则解密失败
                st.error(f'❌File [{File.name}.m ] convert failed!')
