import os

from flask import  g 
from flask_babel import Babel, gettext , lazy_gettext
from flask_babel import _, refresh


from dash import Dash, dcc, html, Input, Output

from src.config import LANGUAGES

base_dir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
print(base_dir)
app = Dash(__name__)

app.server.config["BABEL_TRANSLATION_DIRECTORIES"] = os.path.join(base_dir, "translations")
babel = Babel(app.server)

lang = 'en'

@babel.localeselector
def get_locale(): 
    try:
        language = g.lang_code
    except KeyError:
        language = None
    if language is not None:
        return language
    # result = request.accept_languages.best_match(LANGUAGES.keys())
	# will return language code (en/es/etc).
    return 'en'
	# return result



def render():
    app.layout = html.Div([
        dcc.Dropdown(['en', 'es', 'fr'], 'en', id='demo-dropdown'),
        html.Div(id='dd-output-container'),
        html.H2(_('Please translate me, I am a message or some stuff!')),
    ])
    
    

@app.callback(
    Output('dd-output-container', 'children'),
    Input('demo-dropdown', 'value')
)
def update_output(value):
    g.lang_code = value
    return str(lazy_gettext("Retail is the sale of goods and services to consumers, in contrast to wholesaling, which is sale to business or institutional customers. A retailer purchases goods in large quantities from manufacturers, directly or through a wholesaler, and then sells in smaller quantities to consumers for a profit. Retailers are the final link in the supply chain from producers to consumers.\
Retail markets and shops have a very ancient history, dating back to antiquity. Some of the earliest retailers were itinerant peddlers. Over the centuries, retail shops were transformed from little more than 'rude booths' to the sophisticated shopping malls of the modern era. In the digital age, an increasing number of retailers are seeking to reach broader markets by selling through multiple channels, including both bricks and mortar and online retailing. Digital technologies are also affecting the way that consumers pay for goods and services. Retailing support services may also include the provision of credit, delivery services, advisory services, stylist services and a range of other supporting services.\
Most modern retailers typically make a variety of strategic level decisions including the type of store, the market to be served, the optimal product assortment, customer service, supporting services, and the store's overall market positioning. Once the strategic retail plan is in place, retailers devise the retail mix which includes product, price, place, promotion, personnel, and presentation." ))
render()


if __name__ == '__main__':
    app.run_server(debug=True)