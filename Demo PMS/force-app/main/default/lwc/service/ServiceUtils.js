const getQueryParams = () =>{
        const allQueryParams = {};
        const arrUrl = location.href.split("?");
        if (arrUrl.length > 1) {
            arrUrl[1].split("&").forEach(param => {
                allQueryParams[param.split("=")[0]] = param.split("=")[1];
            });
        }
        return allQueryParams;
    }

const getCookie = ( condition )=>{}
export {getQueryParams, getCookie};